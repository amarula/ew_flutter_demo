// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:ew_2026_flutter_demo/main.dart';

class WeatherPageAppbar extends StatelessWidget implements PreferredSizeWidget {
  const WeatherPageAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF222630),
      actions: [
        IconButton(
          onPressed: () => {
            weatherForecastService
              ..queryWeather()
              ..queryForecast(),
          },
          icon: const Icon(Icons.refresh),
          iconSize: 50,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(54);
}
