// Dart imports:
import 'dart:ffi';
import 'dart:isolate';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:ffi/ffi.dart';

final class WifiService extends Struct {
  external Pointer<Utf8> name;
  @Int32()
  external int strength;
}

class WifiNetwork {
  WifiNetwork(this.name, this.strength);

  String name;
  int strength;
}

typedef MonitorCallback = Void Function(WifiService);
typedef MonitorC = Void Function(Pointer<NativeFunction<MonitorCallback>>);
typedef MonitorDart = void Function(Pointer<NativeFunction<MonitorCallback>>);

final class WifiScanResult extends Struct {
  external Pointer<WifiService> services;
  @Int32()
  external int count;
}

typedef WifiScanC = WifiScanResult Function();
typedef WifiScanDart = WifiScanResult Function();

typedef FreeWifiScanResultC = Void Function(WifiScanResult);
typedef FreeWifiScanResultDart = void Function(WifiScanResult);

typedef WifiConnectC =
    Bool Function(Pointer<Utf8> ssid, Pointer<Utf8> passphrase);
typedef WifiConnectDart =
    bool Function(Pointer<Utf8> ssid, Pointer<Utf8> passphrase);

class NetworkWifiService with ChangeNotifier {
  final _currentNetwork = WifiNetwork('', 0);
  WifiNetwork get currentNetwork => _currentNetwork;

  late MonitorDart _monitor;
  late NativeCallable<MonitorCallback> _monitorCallbackFunc;

  late WifiScanDart _wifiScan;
  late FreeWifiScanResultDart _freeWifiResult;

  late WifiConnectDart _wifiConnect;

  String wifiStrenghtIcon() {
    if (_currentNetwork.name.isEmpty) {
      return 'assets/svg/wifi_offline.svg';
    }
    if (_currentNetwork.strength > 75) {
      return 'assets/svg/wifi_100.svg';
    }
    if (_currentNetwork.strength > 50) {
      return 'assets/svg/wifi_75.svg';
    }
    if (_currentNetwork.strength > 25) {
      return 'assets/svg/wifi_50.svg';
    }
    return 'assets/svg/wifi_25.svg';
  }

  void init() {
    try {
      final lib = DynamicLibrary.open('libcppconnman_adapter.so');

      _monitor = lib.lookup<NativeFunction<MonitorC>>('monitor').asFunction();
      _monitorCallbackFunc = NativeCallable<MonitorCallback>.listener(
        monitorCallback,
      );

      _wifiScan = lib
          .lookup<NativeFunction<WifiScanC>>('wifi_scan')
          .asFunction();
      _freeWifiResult = lib
          .lookup<NativeFunction<FreeWifiScanResultC>>('free_wifi_scan_result')
          .asFunction();

      _wifiConnect = lib
          .lookup<NativeFunction<WifiConnectC>>('free_wifi_scan_result')
          .asFunction();
    } on Exception catch (e) {
      print('Failed to load dynamic library $e');
    }
  }

  void monitorCallback(WifiService service) {
    if (service.name == nullptr) {
      print('WiFi disconnected');

      _currentNetwork.name = '';
      _currentNetwork.strength = 0;
      notifyListeners();
      return;
    }

    final serviceName = service.name.toDartString();
    final serviceStrenght = service.strength;

    print('WiFi connected to $serviceName ($serviceStrenght)');

    _currentNetwork.name = serviceName;
    _currentNetwork.strength = serviceStrenght;
    notifyListeners();
  }

  void startWiFiMonitoring() {
    _monitor(_monitorCallbackFunc.nativeFunction);
  }

  void stopMonitoring() {
    _monitorCallbackFunc.close();
  }

  Future<List<WifiNetwork>> scanWiFiAsync() async {
    return Isolate.run(() {
      final result = _wifiScan();
      final networks = <WifiNetwork>[];

      try {
        for (var i = 0; i < result.count; i++) {
          final service = result.services[i];
          networks.add(
            WifiNetwork(
              service.name.toDartString(),
              service.strength,
            ),
          );
        }
      } finally {
        _freeWifiResult(result);
      }

      return networks;
    });
  }

  bool wifiConnect(String ssid, String password) {
    final ssidPtr = ssid.toNativeUtf8();
    final passPtr = password.toNativeUtf8();

    var success = false;

    try {
      success = _wifiConnect(ssidPtr, passPtr);
      print('WiFi connect success: $success');
    } finally {
      malloc
        ..free(ssidPtr)
        ..free(passPtr);
    }

    return success;
  }
}
