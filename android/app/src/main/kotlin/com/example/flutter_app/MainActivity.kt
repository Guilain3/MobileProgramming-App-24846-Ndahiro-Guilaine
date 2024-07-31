package com.example.flutter_app

import android.content.Intent
import android.content.IntentFilter
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var batteryBroadcastReceiver: BatteryBroadcastReceiver? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Ensure flutterEngine is not null and use it safely
        val flutterEngine = flutterEngine ?: return
        val binaryMessenger = flutterEngine.dartExecutor.binaryMessenger ?: return

        MethodChannel(binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "register_battery_receiver") {
                    batteryBroadcastReceiver = BatteryBroadcastReceiver(
                        MethodChannel(binaryMessenger, CHANNEL)
                    )
                    registerReceiver(
                        batteryBroadcastReceiver,
                        IntentFilter(Intent.ACTION_BATTERY_CHANGED)
                    )
                    result.success("Battery receiver registered")
                } else {
                    result.notImplemented()
                }
            }
    }

    override fun onDestroy() {
        super.onDestroy()
        batteryBroadcastReceiver?.let {
            unregisterReceiver(it)
        }
    }

    companion object {
        private const val CHANNEL = "battery_channel"
    }
}
