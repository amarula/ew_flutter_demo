#include <algorithm>
#include <future>
#include <iostream>

#include <amarula/dbus/connman/gconnman.hpp>

struct WifiService {
  const char *name;
  int strength;
};

struct WifiScanResult {
  WifiService *services;
  int count;
};

extern "C" {

using namespace Amarula::DBus::G::Connman;

static Connman connman_;

void print_technologies() {
  const auto manager = connman_.manager();
  if (!manager) {
    std::cerr << "Failed to get Connman manager\n";
    return;
  }

  const auto technologies = manager->technologies();

  for (const auto &tech : technologies) {
    if (!tech) continue;

    std::cout << "objPath: " << tech->objPath() << "\n";
    std::cout << "name: " << tech->properties().getName() << "\n";
  }
}

void *get_wifi_technology() {
  using TechType = TechProperties::Type;

  auto manager = connman_.manager();
  if (!manager) {
    std::cerr << "Failed to get Connman manager\n";
    return nullptr;
  }

  const auto technologies = manager->technologies();

  auto wifi_tech = std::find_if(
      technologies.begin(), technologies.end(), [](const auto &tech) {
        if (!tech) return false;

        const auto props = tech->properties();
        return props.getType() == TechType::Wifi && props.isPowered();
      });

  if (wifi_tech == technologies.end()) {
    std::cerr << "Failed to find WiFi technology\n";
    return nullptr;
  }

  return (void *)wifi_tech->get();
}

WifiScanResult wifi_scan() {
  using TechType = TechProperties::Type;
  using ServType = ServProperties::Type;

  auto manager = connman_.manager();
  if (!manager) {
    std::cerr << "Failed to get Connman manager\n";
    return {};
  }

  const auto technologies = manager->technologies();

  auto wifi_tech = std::find_if(
      technologies.begin(), technologies.end(), [](const auto &tech) {
        if (!tech) return false;

        const auto props = tech->properties();
        return props.getType() == TechType::Wifi && props.isPowered();
      });

  if (wifi_tech == technologies.end()) {
    std::cerr << "Failed to find WiFi technology\n";
    return {};
  }

  std::promise<bool> promise;
  auto future = promise.get_future();
  wifi_tech->get()->scan(
      [&promise](auto success) { promise.set_value(success); });

  if (!future.get()) {
    std::cerr << "Scan failed\n";
    return {};
  }

  std::vector<WifiService> found_services;

  for (const auto &serv : manager->services()) {
    if (!serv) continue;

    const auto props = serv->properties();
    if (props.getType() == ServType::Wifi && !props.getName().empty()) {
      WifiService s;
      s.name = strdup(props.getName().c_str());

      if (!s.name) {
        for (auto &ws : found_services) {
          free((void *)ws.name);
        }
        std::cerr << "Memory allocation failed (" << __LINE__ << ")\n";
        return {};
      }

      s.strength = (int)props.getStrength();
      found_services.push_back(s);
    }
  }

  if (found_services.empty()) {
    return {nullptr, 0};
  }

  WifiService *result_array =
      (WifiService *)malloc(found_services.size() * sizeof(WifiService));

  if (!result_array) {
    for (auto &ws : found_services) {
      free((void *)ws.name);
    }
    std::cerr << "Memory allocation failed (" << __LINE__ << ")\n";
    return {};
  }

  std::copy(found_services.begin(), found_services.end(), result_array);

  return {result_array, (int)found_services.size()};
}

// IMPORTANT: You need a way to free the memory later to avoid leaks
void free_wifi_scan_result(WifiScanResult result) {
  if (!result.services) return;
  for (int i = 0; i < result.count; i++) {
    free((void *)result.services[i].name);
  }
  free(result.services);
}

bool wifi_connect(const char *ssid, const char *passphrase) {
  using ServType = Amarula::DBus::G::Connman::ServProperties::Type;
  using ServState = Amarula::DBus::G::Connman::ServProperties::State;

  auto manager = connman_.manager();
  if (!manager) {
    std::cerr << "Failed to get Connman manager\n";
    return {};
  }

  {
    std::promise<bool> promise;
    auto future = promise.get_future();
    manager->registerAgent(
        manager->internalAgentPath(),
        [&promise](const auto success) { promise.set_value(success); });
    if (!future.get()) {
      std::cerr << "Failed to register agent\n";
      return false;
    }
  }

  std::string pass(passphrase);
  manager->onRequestInputPassphrase([pass](auto /*service*/) {
    return std::pair<bool, std::string>{true, pass};
  });

  const auto services = manager->services();

  auto new_wifi_it = std::find_if(
      services.begin(), services.end(), [&ssid](const auto &service) {
        if (!service) return false;
        const auto serv_props = service->properties();
        return serv_props.getType() == ServType::Wifi &&
               serv_props.getName() == ssid;
      });

  if (new_wifi_it == services.end()) {
    std::cerr << "WiFi requested not found\n";
    manager->unregisterAgent(manager->internalAgentPath());
    return false;
  }

  auto *const new_wifi = new_wifi_it->get();

  std::promise<bool> promise;
  auto future = promise.get_future();
  new_wifi->connect([&](const auto success) {
    promise.set_value(success);
    manager->unregisterAgent(manager->internalAgentPath());
  });
  return future.get();
}

}  // extern "C"
