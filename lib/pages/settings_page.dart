// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_svg/svg.dart';

// Project imports:
import 'package:ew_2026_flutter_demo/components/settings_card.dart';
import 'package:ew_2026_flutter_demo/components/spinning_indicator.dart';
import 'package:ew_2026_flutter_demo/components/textfield_dialog.dart';
import 'package:ew_2026_flutter_demo/main.dart';
import 'package:ew_2026_flutter_demo/utils/string_extensions.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _showNetworkCards = false;

  Timer? _scanTimer;
  bool _scanInProgress = false;

  Future<void> scan() async {
    print('Scanning');

    setState(() {
      _scanInProgress = true;
    });

    try {
      await networkWifiService.scanWiFi();
    } catch (e) {
      print(e);
    }

    setState(() {
      _scanInProgress = false;
    });
  }

  @override
  void initState() {
    unawaited(scan());

    _scanTimer ??= Timer.periodic(
      const Duration(seconds: 15),
      (timer) => scan(),
    );

    super.initState();
  }

  @override
  void dispose() {
    _scanTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showNetworkCards) {
      return ColoredBox(
        color: const Color(0xFF222630),

        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,

            children: [
              // Back Card
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showNetworkCards = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF373e4e),
                  minimumSize: const Size(560, 64),
                  maximumSize: const Size(560, 64),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 8),

                    FittedBox(
                      fit: BoxFit.none,
                      child: SvgPicture.asset(
                        'assets/svg/back.svg',
                        width: 40,
                        height: 40,
                      ),
                    ),

                    const SizedBox(width: 8),

                    const Text(
                      'Back',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),

              // Current WiFi Card
              ListenableBuilder(
                listenable: networkWifiService,
                builder: (context, child) {
                  return Container(
                    width: 560,
                    height: 128,
                    decoration: BoxDecoration(
                      color: const Color(0xFF373e4e),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'WiFi',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),

                        const Spacer(),

                        Row(
                          spacing: 24,
                          children: [
                            const Spacer(),
                            SvgPicture.asset(
                              networkWifiService.currentNetwork
                                  .wifiStrenghtIcon(),
                              width: 36,
                              height: 36,
                            ),

                            Text(
                              networkWifiService.currentNetwork.name.isEmpty
                                  ? 'Not connected'
                                  : networkWifiService.currentNetwork.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),

                            const Spacer(),
                          ],
                        ),

                        const Spacer(),
                      ],
                    ),
                  );
                },
              ),

              // WiFi Scan Card
              Container(
                width: 560,
                height: 256,
                decoration: BoxDecoration(
                  color: const Color(0xFF373e4e),
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Networks',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),

                        const Spacer(),

                        Visibility(
                          visible: _scanInProgress,
                          child: const SpinningIndicator(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: networkWifiService.networks.length,

                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsetsGeometry.symmetric(
                              vertical: 2,
                            ),

                            child: ElevatedButton(
                              onPressed: () async {
                                await TextFieldDialog.displayAlphanumDialog(
                                  context,
                                  networkWifiService.networks[index].name,
                                  '',
                                  isPassword: true,
                                  (value) {
                                    networkWifiService.wifiConnect(
                                      networkWifiService.networks[index].name,
                                      value,
                                    );
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF222630),
                                minimumSize: const Size(560, 64),
                                maximumSize: const Size(560, 64),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: 8),

                                  FittedBox(
                                    fit: BoxFit.none,
                                    child: SvgPicture.asset(
                                      networkWifiService.networks[index]
                                          .wifiStrenghtIcon(),
                                      width: 40,
                                      height: 40,
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  Text(
                                    networkWifiService.networks[index].name,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ColoredBox(
      color: const Color(0xFF222630),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: [
            SettingsCard(
              title: 'Wifi',
              value: networkWifiService.currentNetwork.name.isEmpty
                  ? 'Not connected'
                  : networkWifiService.currentNetwork.name,
              iconAssetsPath: networkWifiService.currentNetwork
                  .wifiStrenghtIcon(),
              onPressed: () => {
                setState(() {
                  _showNetworkCards = true;
                }),
              },
              onLongPressed: networkWifiService.init,
            ),
            ListenableBuilder(
              listenable: weatherForecastService,
              builder: (context, child) {
                return SettingsCard(
                  title: 'Location',
                  value: weatherForecastService.forecast.isNotEmpty
                      ? weatherForecastService.currentWeather.areaName!
                      : 'Not initialized',
                  iconData: Icons.location_on_outlined,
                  onPressed: () => {
                    TextFieldDialog.displayAlphanumDialog(
                      context,
                      'Location',
                      weatherForecastService.city.capitalize,
                      (value) {
                        weatherForecastService.city = value;
                        setState(() {});
                      },
                    ),
                  },
                  onLongPressed: () {
                    weatherForecastService
                      ..init()
                      ..city = 'Savoca';
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
