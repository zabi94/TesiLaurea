package zabi.flutter.tesi_simone_zanin_140833;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Intent;
import android.os.Build;
import android.os.IBinder;
import android.util.Log;

import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;

public class UploaderService extends Service {

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationCompat.Builder builder = new NotificationCompat.Builder(this, "bg_service")
                    .setContentTitle("Image Tagger")
                    .setContentInfo("Servizio di upload");
            this.startForeground(101, builder.build());
        }

        new Thread(() -> {
            Log.i("IMAGE-TAGGER", "Thread Started");
            try {
                Thread.sleep(5000);
            } catch (InterruptedException e) {
            }
            Log.i("IMAGE-TAGGER", "Thread Stopped, stopping service");
            stopForeground(true);
        }).start();

        return super.onStartCommand(intent, flags, startId);
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }


}
