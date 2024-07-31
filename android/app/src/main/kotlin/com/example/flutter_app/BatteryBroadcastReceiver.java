package com.example.flutter_app;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.BatteryManager;
import android.os.Build;
import androidx.core.app.NotificationCompat;
import io.flutter.plugin.common.MethodChannel;

public class BatteryBroadcastReceiver extends BroadcastReceiver {

    private MethodChannel methodChannel;
    private static final String CHANNEL_ID = "battery_notification_channel";

    public BatteryBroadcastReceiver(MethodChannel methodChannel) {
        this.methodChannel = methodChannel;
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        int status = intent.getIntExtra(BatteryManager.EXTRA_STATUS, -1);
        boolean isCharging = status == BatteryManager.BATTERY_STATUS_CHARGING ||
                status == BatteryManager.BATTERY_STATUS_FULL;

        int level = intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1);
        int scale = intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
        float batteryPct = level / (float) scale * 100;

        if (isCharging && batteryPct > 50) {
            methodChannel.invokeMethod("battery_charged", null);
            showNotification(context, batteryPct);
        }
    }

    private void showNotification(Context context, float batteryPct) {
        NotificationManager notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = new NotificationChannel(CHANNEL_ID, "Battery Notifications", NotificationManager.IMPORTANCE_HIGH);
            channel.setDescription("Notifications for battery status");
            notificationManager.createNotificationChannel(channel);
        }

        Intent intent = new Intent(context, MainActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT);

        NotificationCompat.Builder builder = new NotificationCompat.Builder(context, CHANNEL_ID)
                .setSmallIcon(R.drawable.ic_battery)
                .setContentTitle("Battery Status")
                .setContentText("Battery is charging: " + (int) batteryPct + "%")
                .setPriority(NotificationCompat.PRIORITY_HIGH)
                .setContentIntent(pendingIntent)
                .setAutoCancel(true);

        notificationManager.notify(1, builder.build());
    }

    public static IntentFilter getIntentFilter() {
        return new IntentFilter(Intent.ACTION_BATTERY_CHANGED);
    }
}
