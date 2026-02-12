// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_svg/svg.dart';

// Project imports:
import 'package:ew_2026_flutter_demo/pages/main_page.dart';
import 'package:ew_2026_flutter_demo/services/network_wifi_service.dart';
import 'package:ew_2026_flutter_demo/services/weather_forecast_service.dart';

final weatherForecastService = WeatherForecastService();

final networkWifiService = NetworkWifiService();

void main() {
  print('Debug mode: ${kDebugMode ? 'ON' : 'OFF'}');

  try {
    networkWifiService.init();
  } catch (e) {
    print('Network init failed');
  }

  weatherForecastService
    ..init()
    ..city = 'Savoca';

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Embedded World Flutter Thermostat',
      theme: ThemeData(
        fontFamily: 'Inter',
        colorScheme: const ColorScheme.dark(),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: EdgeInsets.zero,
            minimumSize: const Size(48, 48),
            maximumSize: const Size(48, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const DefaultSvgTheme(
        theme: SvgTheme(currentColor: Colors.white),
        child: MainPage(),
      ),
    );
  }
}
