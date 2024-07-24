import 'dart:async';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BatteryService {
  final Battery _battery = Battery();
  StreamSubscription<BatteryState>? _batteryStateSubscription;

  void initialize(BuildContext context, int threshold) {
    _batteryStateSubscription = _battery.onBatteryStateChanged.listen((BatteryState state) async {
      if (state == BatteryState.charging) {
        int batteryLevel = await _battery.batteryLevel;
        if (batteryLevel >= threshold) {
          Fluttertoast.showToast(msg: "Battery charged to $batteryLevel%");
          // Implement ringtone functionality here if required
        }
      }
    });
  }

  void dispose() {
    _batteryStateSubscription?.cancel();
  }
}
