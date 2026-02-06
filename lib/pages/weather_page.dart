// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:ew_2026_flutter_demo/widgets/weather_forecast_widget.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF222630),
      body: Center(
        child: WeatherForecastWidget(),
      ),
    );
  }
}
