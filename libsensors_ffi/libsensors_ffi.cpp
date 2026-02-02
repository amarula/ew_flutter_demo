extern "C" {

static double temperature_ = 0;
static double humidity_ = 0;
static double pressure_ = 0;

double temperature() { return temperature_; }

double humidity() { return humidity_; }

double pressure() { return pressure_; }

}  // extern "C"