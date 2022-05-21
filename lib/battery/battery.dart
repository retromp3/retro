/*import 'package:flutter/material.dart';
import 'dart:async';
import 'package:battery/battery.dart';
import 'package:device_info/device_info.dart';

class BatteryInformation {
  final int batteryLevel;
  BatteryInformation(this.batteryLevel);
}

class DeviceInformationService {
  bool _broadcastBattery = false;
  Battery _battery = Battery();

  Future _broadcastBatteryLevel() async {
    _broadcastBattery = true;
    while (_broadcastBattery) {
      var batteryLevel = await _battery.batteryLevel;
      _batteryLevelController
          .add(BatteryInformation(batteryLevel));
      await Future.delayed(Duration(seconds: 5));
    }
  }

  void stopBroadcast() {
    _broadcastBattery = false;
  }
}

Stream<BatteryInformation> get batteryLevel => _batteryLevelController.stream;
  StreamController<BatteryInformation> _batteryLevelController =
      StreamController<BatteryInformation>();

      */