// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';

class DailyWeather {
  String weekDay = '';
  String icon = '';
  String tempMax = '';
  String tempMin = '';
}

class WeatherForecastService with ChangeNotifier {
  String key = '47a0fdb9d9cdf45ea46d5ebe5d8e1596';
  late WeatherFactory ws;

  late Weather _currentWeather;
  Weather get currentWeather => _currentWeather;

  final List<DailyWeather> _forecast = [];
  List<DailyWeather> get forecast => _forecast;

  void init() {
    ws = WeatherFactory(key);
  }

  Future<void> queryWeather() async {
    // final weather =
    //     await ws.currentWeatherByLocation(44.7839, 10.8797); // CARPI
    final weather =
        await ws.currentWeatherByLocation(49.4543, 11.0746); // NORIMBERGA
    _currentWeather = weather;

    notifyListeners();
  }

  Future<void> queryForecast() async {
    // final data = await ws.fiveDayForecastByLocation(44.7839, 10.8797); // CARPI
    final data =
        await ws.fiveDayForecastByLocation(49.4543, 11.0746); // NORIMBERGA

    for (final weather in data) {
      final d = DailyWeather()
        ..weekDay = DateFormat.E().format(weather.date!)
        ..icon = weather.weatherIcon!
        ..tempMax = weather.tempMax!.celsius!.toStringAsFixed(1)
        ..tempMin = weather.tempMin!.celsius!.toStringAsFixed(1);

      var found = false;
      for (final dailyWeather in forecast) {
        if (dailyWeather.weekDay == d.weekDay) {
          if (weather.date!.hour == 13) {
            dailyWeather.icon = d.icon;
          }
          if (double.parse(d.tempMax) > double.parse(dailyWeather.tempMax)) {
            dailyWeather.tempMax = d.tempMax;
          }
          if (double.parse(d.tempMin) < double.parse(dailyWeather.tempMin)) {
            dailyWeather.tempMin = d.tempMin;
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
