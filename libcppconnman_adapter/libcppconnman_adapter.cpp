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

}  // extern "C"