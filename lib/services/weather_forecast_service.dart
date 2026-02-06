// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';

class DailyWeather {
  String weekDay = '';
  String icon = '';
  String temperature = '';
}

class WeatherForecastService with ChangeNotifier {
  late WeatherFactory _ws;

  final String _key = '47a0fdb9d9cdf45ea46d5ebe5d8e1596';

  late String _city;
  String get city => _city;
  set city(String newCity) {
    _city = newCity;
    unawaited(queryWeather());
    unawaited(queryForecast());
  }

  late Weather _currentWeather;
  Weather get currentWeather => _currentWeather;

  final List<DailyWeather> _forecast = [];
  List<DailyWeather> get forecast => _forecast;

  void init() {
    _ws = WeatherFactory(_key);
  }

  Future<void> queryWeather() async {
    final weather = await _ws.currentWeatherByCityName(_city);
    _currentWeather = weather;

    notifyListeners();
  }

  Future<void> queryForecast() async {
    final data = await _ws.fiveDayForecastByCityName(_city);

    for (final weather in data) {
      final d = DailyWeather()
        ..weekDay = DateFormat.E().format(weather.date!)
        ..icon = weather.weatherIcon!
        ..temperature = weather.temperature!.celsius!.toStringAsFixed(1);

      var found = false;
      for (final dailyWeather in forecast) {
        if (dailyWeather.weekDay == d.weekDay) {
          if (weather.date!.hour == 13) {
            dailyWeather.icon = d.icon;
          }
          if (double.parse(d.temperature) >
              double.parse(dailyWeather.temperature)) {
            dailyWeather.temperature = d.temperature;
          }
          found = true;
          break;
        }
      }

      if (!found) {
        forecast.add(d);
      }
    }

    notifyListeners();
  }
}
