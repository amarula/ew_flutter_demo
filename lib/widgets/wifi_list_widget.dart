// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Project imports:
import 'package:ew_2026_flutter_demo/main.dart';
import 'package:ew_2026_flutter_demo/services/network_wifi_service.dart';

class WifiListWidget extends StatefulWidget {
  const WifiListWidget({
    super.key,
    this.onWifiSelected,
  });

  final ValueChanged<WifiNetwork>? onWifiSelected;

  @override
  State<WifiListWidget> createState() => _WifiListWidgetState();
}

class _WifiListWidgetState extends State<WifiListWidget> {
  late List<WifiNetwork> _scannedNetworks = [];
  bool _isScanning = false;

  Widget noDataAvailable() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          const Text(
            'No Wifi found',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w400,
            ),
          ),

          const SizedBox(height: 24),

          TextButton.icon(
            style: TextButton.styleFrom(
              side: const BorderSide(color: Colors.grey, width: 2),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () async {
              setState(() {
                _isScanning = true;
              });
              final scanned = await networkWifiService.scanWiFiAsync();
              setState(() {
                _scannedNetworks = scanned;
                _isScanning = false;
              });
            },
            icon: const Icon(Icons.wifi_find),
            label: const Text(
              'Scan for Wifi',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget wifiItem(WifiNetwork network) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: const Color(0xFF373e4e),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        clipBehavior: Clip.hardEdge,
        child: ListTile(
          title: Text(network.name),
          minTileHeight: 64,
          onTap: () => {
            widget.onWifiSelected?.call(network),
          },
          leading: SvgPicture.asset(
            'assets/svg/wifi_${network.strength}.svg',
            width: 32,
            height: 32,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isScanning) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_scannedNetworks.isEmpty) {
      return noDataAvailable();
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 16,
        children: [
          SizedBox(
            width: double.infinity,
            child: Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 32),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _scannedNetworks.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 4,
                  color: Colors.transparent,
                ),
                itemBuilder: (context, index) {
                  final network = _scannedNetworks[index];
                  return wifiItem(network);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
