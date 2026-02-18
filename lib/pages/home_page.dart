// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_svg/svg.dart';
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
  double _setpoint = 21;
  bool _heating = false;
  bool _turnedOn = true;

  void _incrementSetpoint() {
    setState(() {
      _setpoint += 0.5;
      _turnedOn = _setpoint != sensorsService.temperature;
      _heating = _setpoint > sensorsService.temperature;
    });
  }

  void _decrementSetpoint() {
    setState(() {
      _setpoint -= 0.5;
      _turnedOn = _setpoint != sensorsService.temperature;
      _heating = _setpoint > sensorsService.temperature;
    });
  }

  @override
  void initState() {
    _turnedOn = _setpoint != sensorsService.temperature;
    _heating = _setpoint > sensorsService.temperature;
    super.initState();
  }

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
                    onPressed: _incrementSetpoint,
                    onLongPressed: _incrementSetpoint,
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Visibility(
                        visible: _turnedOn,
                        replacement: const Padding(
                          padding: EdgeInsetsGeometry.all(165),
                        ),
                        child: Lottie.asset(
                          'assets/lottie/${_heating ? 'heating' : 'cooling'}_ring.json',
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _setpoint.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 64),
                          ),
                          Text(_heating ? 'Heat' : 'Cool'),
                        ],
                      ),
                    ],
                  ),
                  TempChangeButton(
                    icon: const Icon(Icons.expand_more),
                    onPressed: _decrementSetpoint,
                    onLongPressed: _decrementSetpoint,
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
                        icon: SvgPicture.asset(
                          'assets/svg/temperature.svg',
                          width: 32,
                        ),
                        unit: '°C',
                      ),
                      SensorValueCard(
                        title: 'Humidity',
                        value: sensorsService.humidity.toStringAsFixed(0),
                        unit: '%',
                        icon: SvgPicture.asset(
                          'assets/svg/humidity_home.svg',
                          width: 32,
                        ),
                      ),
                      SensorValueCard(
                        title: 'Pressure',
                        value: sensorsService.humidity.toStringAsFixed(0),
                        icon: SvgPicture.asset(
                          'assets/svg/wind.svg',
                          width: 32,
                        ),
                        unit: 'hPa',
                      ),
                      PowerSwitch(
                        turnedOn: _turnedOn,
                        onChanged: (_) {
                          setState(() {
                            _turnedOn =
                                !_turnedOn &&
                                _setpoint != sensorsService.temperature;
                          });
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
