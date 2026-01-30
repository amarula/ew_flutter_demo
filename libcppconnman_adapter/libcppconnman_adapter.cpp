#include <algorithm>
#include <iostream>

#include <amarula/dbus/connman/gconnman.hpp>

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

}  // extern "C"