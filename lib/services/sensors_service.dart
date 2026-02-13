// Dart imports:
import 'dart:async';
import 'dart:ffi';

// Flutter imports:
import 'package:flutter/material.dart';

typedef DataReadC = Double Function();
typedef DataReadDart = double Function();

typedef StartDataPollingC = Void Function();
typedef StartDataPollingDart = void Function();

class SensorsService with ChangeNotifier {
  double temperature = 0;
  late DataReadDart _readTemperature;

  double humidity = 0;
  late DataReadDart _readHumidity;

  double pressure = 0;
  late DataReadDart _readPressure;

  late StartDataPollingDart _startDataPolling;

  void init() {
    try {
      final lib = DynamicLibrary.open('libsensors_ffi.so.1');

      _readTemperature = lib
          .lookup<NativeFunction<DataReadC>>('temperature')
          .asFunction();

      _readHumidity = lib
          .lookup<NativeFunction<DataReadC>>('humidity')
          .asFunction();

      _readPressure = lib
          .lookup<NativeFunction<DataReadC>>('pressure')
          .asFunction();

      _startDataPolling = lib
          .lookup<NativeFunction<StartDataPollingC>>('start_data_polling')
          .asFunction();

      _startDataPolling();

      Timer.periodic(const Duration(seconds: 1), (_) {
        temperature = _readTemperature();
        humidity = _readHumidity();
        pressure = _readPressure();
        notifyListeners();

        print('temperature=$temperature');
        print('humidity=$humidity');
        print('pressure=$pressure');
      });
    } catch (e) {
      print('Sensors service init failed: $e');
      return;
    }

    print('Sensors service init success');
  }
}
