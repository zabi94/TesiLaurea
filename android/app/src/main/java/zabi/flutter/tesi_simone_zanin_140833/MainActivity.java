package zabi.flutter.tesi_simone_zanin_140833;

import android.content.Intent;
import android.os.Build;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {

    private Intent serviceIntent;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        serviceIntent = new Intent(this, UploaderService.class);

        MethodChannel channel = new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), "zabi.flutter.tesi_simone_zanin_140833/uploader");

        channel.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
                switch (call.method) {
                    case "start":
                        startUploaderService();
                        result.success(0);
                        break;
                    case "stop":
                    case "add":
                    case "get":
                        result.error("NOT-IMPLEMENTED", "not implemented", null);
                        break;
                    default:
                        result.error("NO-METHOD","not existent", null);
                }
            }
        });

    }

    public void startUploaderService() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(serviceIntent);
        } else {
            startService(serviceIntent);
        }
    }
}
