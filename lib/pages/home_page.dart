// Dart imports:
import 'dart:async';
import 'dart:io';
import 'dart:math';

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

class HeatingController extends ChangeNotifier {
  HeatingController({
    required double setpoint,
  }) : _setpoint = setpoint {
    _evaluate();
    sensorsService.addListener(_evaluate);
  }

  double _setpoint;
  double get setpoint => _setpoint;

  bool turnedOn = false;
  bool heating = false;

  void increment() {
    _setpoint += 0.5;
    _evaluate();
  }

  void decrement() {
    _setpoint -= 0.5;
    _evaluate();
  }

  void playSound() {
    final prefix = heating ? 'heating' : 'cooling';
    final names = ['barsanti', 'binacchi', 'gonzalez', 'puzzillo'];
    final picked = names[Random().nextInt(names.length)];

    unawaited(
      Process.run('aplay', [
        '-v',
        '-D',
        'plughw:0,0',
        '-c',
        '2',
        '-M',
        '/home/sounds/${prefix}_$picked.wav',
      ]),
    );
  }

  void _evaluate() {
    turnedOn = _setpoint != sensorsService.temperature;
    final oldHeating = heating;
    heating = _setpoint > sensorsService.temperature;
    if (turnedOn && oldHeating != heating) {
      playSound();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    sensorsService.removeListener(_evaluate);
    super.dispose();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HeatingController _heatingController;

  void _incrementSetpoint() => _heatingController.increment();
  void _decrementSetpoint() => _heatingController.decrement();

  @override
  void initState() {
    _heatingController = HeatingController(
      setpoint: 21,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF222630),
      body: ListenableBuilder(
        listenable: _heatingController,
        builder: (context, child) {
          return Center(
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
                            visible: _heatingController.turnedOn,
                            replacement: const Padding(
                              padding: EdgeInsetsGeometry.all(165),
                            ),
                            child: Lottie.asset(
                              'assets/lottie/${_heatingController.heating ? 'heating' : 'cooling'}_ring.json',
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _heatingController.setpoint.toStringAsFixed(1),
                                style: const TextStyle(fontSize: 64),
                              ),
                              Text(
                                _heatingController.heating ? 'Heat' : 'Cool',
                              ),
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
                          const SizedBox(width: 8),
                          SensorValueCard(
                            title: 'Temperature',
                            value: sensorsService.temperature.toStringAsFixed(
                              1,
                            ),
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
                            turnedOn: _heatingController.turnedOn,
                            onChanged: (_) {
                              setState(() {
                                _heatingController.turnedOn =
                                    !_heatingController.turnedOn &&
                                    _heatingController.setpoint !=
                                        sensorsService.temperature;
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
          );
        },
      ),
    );
  }
}
