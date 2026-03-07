#include <algorithm>
#include <atomic>
#include <cmath>
#include <fstream>
#include <iostream>
#include <mutex>
#include <sstream>
#include <string>
#include <thread>
#include <vector>

enum SensorType { TEMPERATURE = 1, HUMIDITY = 2, PRESSURE = 3, UNKNOWN = -1 };

struct Sensor {
  std::string name;
  SensorType type;
  double alpha{1.0};
  double smoothed_value{NAN};
};

std::vector<Sensor> parse_sensors_config(const std::string& filename) {
  std::vector<Sensor> sensors;
  std::ifstream file(filename);
  std::string line;

  while (std::getline(file, line)) {
    if (line.empty() || line[0] == '#') continue;

    std::stringstream ss(line);
    std::string key;

    if (ss >> key) {
      if (key == "sensor_name") {
        Sensor s;
        ss >> s.name;
        s.type = UNKNOWN;
        sensors.push_back(s);
      } else if (key == "sensor_type" && !sensors.empty()) {
        int typeVal;
        if (ss >> typeVal) {
          if (typeVal >= TEMPERATURE && typeVal <= PRESSURE) {
            sensors.back().type = static_cast<SensorType>(typeVal);
          }
        }
      } else if (key == "sensor_alpha" && !sensors.empty()) {
        double alphaVal;
        if (ss >> alphaVal) {
          alphaVal = std::max(0.0, std::min(1.0, alphaVal));
          sensors.back().alpha = alphaVal;
        }
      }
    }
  }
  return sensors;
}

double read_sensor_file(const std::string& path) {
  std::ifstream file(path);
  std::string value;

  if (file.is_open()) {
    std::getline(file, value);
  } else {
    return NAN;
  }

  try {
    return std::stod(value);
  } catch (const std::exception&) {
    return NAN;
  }
}

double convert_raw_humidity(double value) {
  auto rh = -6.0f + 125.0f * (value / 65535.0f);

  if (rh < 0.0f) rh = 0.0f;
  if (rh > 100.0f) rh = 100.0f;

  return rh;
}

extern "C" {

static std::thread polling_thread_{};

/*
 * To fix sensor noise we use Exponential Moving Average (EMA) approach, where
 * `value = (alpha * new_reading) + ((1 - alpha) * old_value)`
 * where alpha is a smoothing factor to match how noisy is the sensor.
 */

static std::atomic<double> temperature_{NAN};
double temperature() { return temperature_; }

static std::atomic<double> humidity_{NAN};
double humidity() { return humidity_; }

static std::atomic<double> pressure_{NAN};
double pressure() { return pressure_; }

static std::once_flag polling_started_;

void start_data_polling() {
  std::call_once(polling_started_, []() {
    std::thread([]() {
      using namespace std::chrono_literals;

      auto sensors = parse_sensors_config("/etc/sensors.cfg");

      while (true) {
        std::this_thread::sleep_for(1s);

        auto temp_sum = 0.0;
        auto temp_count = 0;

        auto hum_sum = 0.0;
        auto hum_count = 0;

        auto press_sum = 0.0;
        auto press_count = 0;

        for (auto& s : sensors) {
          if (s.type == UNKNOWN) continue;

          auto raw_val = read_sensor_file(s.name);
          if (std::isnan(raw_val)) continue;

          // Typical mC to C conversion
          if (s.type == TEMPERATURE) {
            // SHT4x sensor
            raw_val = raw_val / 1000.0f;
          } else if (s.type == HUMIDITY) {
            // SHT4x sensor
            raw_val = convert_raw_humidity(raw_val);
          } else if (s.type == PRESSURE) {
            // LPS22HB sensor
            raw_val = raw_val / 4096.0f;
          }
          std::cout << s.name << " - " << raw_val << '\n';

          if (std::isnan(s.smoothed_value)) {
            s.smoothed_value = raw_val;
          } else {
            s.smoothed_value =
                (s.alpha * raw_val) + ((1.0f - s.alpha) * s.smoothed_value);
          }

          switch (s.type) {
            case TEMPERATURE:
              temp_sum += s.smoothed_value;
              temp_count++;
              break;
            case HUMIDITY:
              hum_sum += s.smoothed_value;
              hum_count++;
              break;
            case PRESSURE:
              press_sum += s.smoothed_value;
              press_count++;
              break;
            default:
              break;
          }
        }

        if (temp_count > 0) {
          temperature_ = temp_sum / temp_count;
        }
        if (hum_count > 0) {
          humidity_ = hum_sum / hum_count;
        }
        if (press_count > 0) {
          pressure_ = press_sum / press_count;
        }
      }
    }).detach();
  });
}

}  // extern "C"