// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:ew_2026_flutter_demo/components/keyboard_text_input.dart';
import 'package:ew_2026_flutter_demo/components/settings_card.dart';
import 'package:ew_2026_flutter_demo/main.dart';
import 'package:ew_2026_flutter_demo/services/network_wifi_service.dart';
import 'package:ew_2026_flutter_demo/widgets/wifi_list_widget.dart';

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({super.key});

  @override
  State<SettingsWidget> createState() => _SettingtWidgetState();
}

class _SettingtWidgetState extends State<SettingsWidget> {
  bool _showWifiList = false;
  bool _showLocationInput = false;
  bool _showWifiPasswordInput = false;
  WifiNetwork? _selectedNetwork;

  @override
  Widget build(BuildContext context) {
    if (_showWifiList) {
      return WifiListWidget(
        onWifiSelected: (network) {
          setState(() {
            _showWifiList = false;
            _selectedNetwork = network;
            _showWifiPasswordInput = true;
          });
        },
      );
    }

    if (_showLocationInput || _showWifiPasswordInput) {
      return KeyboardTextInput(
        onReturn: (value) {
          if (_showWifiPasswordInput) {
            final connected = networkWifiService.wifiConnect(
              _selectedNetwork!.name,
              value,
            );
            if (connected) {
              print('Connected to ${_selectedNetwork!.name}');
            } else {
              print('Failed to connect to ${_selectedNetwork!.name}');
            }
            setState(() {
              _showWifiPasswordInput = false;
              _selectedNetwork = null;
            });
          } else {
            weatherForecastService.city = value;
            setState(() {
              _showLocationInput = false;
            });
          }
        },
      );
    }

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SettingsCard(
            title: 'Wifi',
            value: networkWifiService.currentNetwork.name.isEmpty
                ? 'Not connected'
                : networkWifiService.currentNetwork.name,
            iconAssetsPath: networkWifiService.wifiStrenghtIcon(),
            onPressed: () => {
              setState(() {
                _showWifiList = true;
              }),
            },
          ),
          const SizedBox(width: 24),
          SettingsCard(
            title: 'Location',
            value: weatherForecastService.city,
            iconData: Icons.location_on_outlined,
            onPressed: () => {
              setState(() {
                _showLocationInput = true;
              }),
            },
          ),
        ],
      ),
    );
  }
}
