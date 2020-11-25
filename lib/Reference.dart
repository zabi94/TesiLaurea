import 'dart:io';

import 'package:device_info/device_info.dart';

class Reference {
  static const String appTitle = "Image Tagger";

  static const String prefs_server = "SelectedServer";
  static const String prefs_port = "SelectedPort";

  static bool isAndroid11 = false;

  static Future<Null> checkPlatform() {
    if (!Platform.isAndroid) {
      return Future.value(null);
    }
    return DeviceInfoPlugin().androidInfo.then((adi) {
      isAndroid11 = adi.version.sdkInt >= 30;
    });
  }
}