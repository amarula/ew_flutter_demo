// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:ew_2026_flutter_demo/main.dart';
import 'package:ew_2026_flutter_demo/utils/string_extensions.dart';

class CurrentWeatherCard extends StatelessWidget {
  const CurrentWeatherCard({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    return Container(
      width: 560,
      height: 184,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF373e4e),
        borderRadius: BorderRadius.circular(32),
      ),

      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(
                  left: 6,
                  right: 8,
                  top: 8,
                  bottom: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF4c556c),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  spacing: 4,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                    Text(
                      weatherForecastService.currentWeather.areaName!,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Text(
                DateFormat('EEEE').format(today),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('d MMM, y').format(today),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const Spacer(),

          SvgPicture.asset(
            'assets/svg/${weatherForecastService.currentWeather.weatherIcon}.svg',
            width: 120,
            height: 120,
          ),

          const Spacer(),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                ' ${weatherForecastService.currentWeather.temperature!.celsius!.toStringAsFixed(1)} °C',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Spacer(),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svg/humidity.svg',
                    width: 20,
                    height: 20,
                  ),
                  Text(
                    '${weatherForecastService.currentWeather.humidity}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              Text(
                weatherForecastService
                    .currentWeather
                    .weatherDescription!
                    .capitalize,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                'Feels like ${weatherForecastService.currentWeather.tempFeelsLike!.celsius!.toStringAsFixed(0)}°',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
