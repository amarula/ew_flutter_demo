// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:ew_2026_flutter_demo/components/current_weather_card.dart';
import 'package:ew_2026_flutter_demo/components/day_forecast_card.dart';
import 'package:ew_2026_flutter_demo/components/sun_time_card.dart';
import 'package:ew_2026_flutter_demo/components/weather_detail_card.dart';
import 'package:ew_2026_flutter_demo/main.dart';

class WeatherForecastWidget extends StatefulWidget {
  const WeatherForecastWidget({
    super.key,
  });

  @override
  State<WeatherForecastWidget> createState() => _WeatherForecastWidgetState();
}

class _WeatherForecastWidgetState extends State<WeatherForecastWidget> {
  String degreeToCompass(double degree) {
    final array = [
      'N',
      'NNE',
      'NE',
      'ENE',
      'E',
      'ESE',
      'SE',
      'SSE',
      'S',
      'SSW',
      'SW',
      'WSW',
      'W',
      'WNW',
      'NW',
      'NNW',
    ];

    final v = ((degree / 22.5) + .5).toInt();
    return array[(v % 16)];
  }

  Widget noDataAvailable() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          SvgPicture.asset(
            'assets/svg/weather_none.svg',
            width: 120,
            height: 120,
          ),

          const SizedBox(height: 24),

          const Text(
            'No data available',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: weatherForecastService,
      builder: (context, child) {
        if (weatherForecastService.forecast.isEmpty) {
          return noDataAvailable();
        }

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 16,
            children: [
              const Spacer(
                flex: 3,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 16,
                children: [
                  const CurrentWeatherCard(),

                  WeatherDetailCard(
                    title: 'Wind',
                    icon: 'assets/svg/wind.svg',
                    value: '${weatherForecastService.currentWeather.windSpeed}',
                    unit: ' m/s',
                    footer: degreeToCompass(
                      weatherForecastService.currentWeather.windDegree!,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 16,
                  children: [
                    const Spacer(),

                    DayForecastCard(
                      weather: weatherForecastService.forecast[0],
                    ),

                    DayForecastCard(
                      weather: weatherForecastService.forecast[1],
                    ),

                    DayForecastCard(
                      weather: weatherForecastService.forecast[2],
                    ),

                    DayForecastCard(
                      weather: weatherForecastService.forecast[3],
                    ),

                    DayForecastCard(
                      weather: weatherForecastService.forecast[4],
                    ),

                    Column(
                      spacing: 8,
                      children: [
                        SunTimeCard(
                          label: 'Sunrise',
                          time: DateFormat('Hm').format(
                            weatherForecastService.currentWeather.sunrise!,
                          ),
                          icon: 'assets/svg/sunrise.svg',
                        ),
                        SunTimeCard(
                          label: 'Sunset',
                          time: DateFormat('Hm').format(
                            weatherForecastService.currentWeather.sunset!,
                          ),
                          icon: 'assets/svg/sunset.svg',
                        ),
                      ],
                    ),

                    const Spacer(),
                  ],
                ),
              ),

              const Spacer(
                flex: 3,
              ),
            ],
          ),
        );
      },
    );
  }
}
