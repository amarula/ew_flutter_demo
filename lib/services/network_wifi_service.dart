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

  String wifiStrenghtIcon() {
    if (name.isEmpty) {
      return 'assets/svg/wifi_offline.svg';
    }
    if (strength > 75) {
      return 'assets/svg/wifi_100.svg';
    }
    if (strength > 50) {
      return 'assets/svg/wifi_75.svg';
    }
    if (strength > 25) {
      return 'assets/svg/wifi_50.svg';
    }
    return 'assets/svg/wifi_25.svg';
  }
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

late MonitorDart _monitor;
late NativeCallable<MonitorCallback> _monitorCallbackFunc;

late WifiConnectDart _wifiConnect;

class NetworkWifiService with ChangeNotifier {
  final _currentNetwork = WifiNetwork('', 0);
  WifiNetwork get currentNetwork => _currentNetwork;

  List<WifiNetwork> _networks = [];
  List<WifiNetwork> get networks => _networks;

  static DynamicLibrary get _lib =>
      DynamicLibrary.open('libcppconnman_adapter.so.1');

  static WifiScanDart get _staticWifiScan =>
      _lib.lookup<NativeFunction<WifiScanC>>('wifi_scan').asFunction();

  static FreeWifiScanResultDart get _staticFreeWifiResult => _lib
      .lookup<NativeFunction<FreeWifiScanResultC>>('free_wifi_scan_result')
      .asFunction();

  void init() {
    try {
      final lib = DynamicLibrary.open('libcppconnman_adapter.so.1');

      _monitor = lib.lookup<NativeFunction<MonitorC>>('monitor').asFunction();
      _monitorCallbackFunc = NativeCallable<MonitorCallback>.listener(
        monitorCallback,
      );

      _wifiConnect = lib
          .lookup<NativeFunction<WifiConnectC>>('wifi_connect')
          .asFunction();

      startWiFiMonitoring();
    } on Exception catch (e) {
      print('Network service initaliaziation failed: $e');
      return;
    }
    print('Network service initaliaziation success');
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

  Future<void> scanWiFi() async {
    final scannedNetworks = await Isolate.run(() {
      final result = _staticWifiScan();
      final networks = <WifiNetwork>[];

      try {
        for (var i = 0; i < result.count; i++) {
          final service = result.services[i];
          networks.add(
            WifiNetwork(service.name.toDartString(), service.strength),
          );
        }
        return networks;
      } finally {
        _staticFreeWifiResult(result);
      }
    });

    _networks = scannedNetworks;
    notifyListeners();
  }

  bool wifiConnect(String ssid, String password) {
    var success = false;

    success = _wifiConnect(ssid.toNativeUtf8(), password.toNativeUtf8());
    print('WiFi connect success: $success');

    return success;
  }
}
