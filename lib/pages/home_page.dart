// Flutter imports:
import 'package:ew_2026_flutter_demo/components/sensor_value_card.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:lottie/lottie.dart';

// Project imports:
import 'package:ew_2026_flutter_demo/components/power_switch.dart';
import 'package:ew_2026_flutter_demo/components/temp_change_button.dart';

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
            SizedBox(
              height: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 16),
                  const SensorValueCard(
                    title: 'Temperature',
                    value: '24',
                    icon: Icon(Icons.thermostat, size: 32),
                    unit: '°C',
                  ),
                  const SensorValueCard(
                    title: 'Humidity',
                    value: '60',
                    unit: '%',
                    icon: Icon(
                      Icons.water_drop,
                      size: 32,
                    ),
                  ),
                  const SensorValueCard(
                    title: 'Pressure',
                    value: '1013',
                    icon: Icon(Icons.air, size: 32),
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
            ),
          ],
        ),
      ),
    );
  }
}
