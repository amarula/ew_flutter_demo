// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_svg/svg.dart';

// Project imports:
import 'package:ew_2026_flutter_demo/services/weather_forecast_service.dart';

class DayForecastCard extends StatelessWidget {
  const DayForecastCard({
    required this.weather,
    super.key,
  });

  final DailyWeather weather;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 200,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF373e4e),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            weather.weekDay,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),

          Container(
            height: 1,
            width: 30,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withAlpha(0),
                  Colors.white,
                  Colors.white.withAlpha(0),
                ],
              ),
            ),
          ),

          SvgPicture.asset(
            'assets/svg/${weather.icon}.svg',
            width: 56,
            height: 56,
          ),

          Text(
            weather.temperature,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
