// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:lottie/lottie.dart';

// Project imports:
import 'package:ew_2026_flutter_demo/components/power_switch.dart';
import 'package:ew_2026_flutter_demo/components/sensor_value_card.dart';
import 'package:ew_2026_flutter_demo/components/temp_change_button.dart';
import 'package:ew_2026_flutter_demo/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isHeating = false;
  bool _turnedOn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF222630),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 330,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TempChangeButton(
                    icon: const Icon(Icons.expand_less),
                    onPressed: () {
                      isHeating = true;
                      setState(() {});
                    },
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Lottie.asset(
                        'assets/lottie/${isHeating ? 'heating' : 'cooling'}_ring.json',
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('24°', style: TextStyle(fontSize: 72)),
                          Text(isHeating ? 'Heat' : 'Cool'),
                        ],
                      ),
                    ],
                  ),
                  TempChangeButton(
                    icon: const Icon(Icons.expand_more),
                    onPressed: () {
                      isHeating = false;
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),

            ListenableBuilder(
              listenable: sensorsService,
              builder: (context, child) {
                return SizedBox(
                  height: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 16),
                      SensorValueCard(
                        title: 'Temperature',
                        value: sensorsService.temperature.toStringAsFixed(1),
                        icon: const Icon(Icons.thermostat, size: 32),
                        unit: '°C',
                      ),
                      SensorValueCard(
                        title: 'Humidity',
                        value: sensorsService.humidity.toStringAsFixed(0),
                        unit: '%',
                        icon: const Icon(
                          Icons.water_drop,
                          size: 32,
                        ),
                      ),
                      SensorValueCard(
                        title: 'Pressure',
                        value: sensorsService.humidity.toStringAsFixed(0),
                        icon: const Icon(Icons.air, size: 32),
                        unit: 'hPa',
                      ),
                      PowerSwitch(
                        turnedOn: _turnedOn,
                        onChanged: (value) {
                          _turnedOn = value;
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
