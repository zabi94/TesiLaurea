import 'dart:io';

import 'package:flutter/services.dart';

abstract class UploaderService {

  static UploaderService getInstance() {
    if (Platform.isAndroid) {
      return AndroidUploaderService.INSTANCE;
    }
    return OtherUploaderService.INSTANCE;
  }

  void start();
  void stop();
  void sendJob();
  void getJobs();

}

class AndroidUploaderService extends UploaderService {

  // ignore: non_constant_identifier_names
  static final UploaderService INSTANCE = new AndroidUploaderService();
  static final MethodChannel channel = MethodChannel("zabi.flutter.tesi_simone_zanin_140833/uploader");

  @override
  void getJobs() {
  }

  @override
  void sendJob() {
  }

  @override
  void start() async {
    await channel.invokeMethod("start");
  }

  @override
  void stop() async {
    await channel.invokeMethod("stop");
  } 
}

class OtherUploaderService extends UploaderService {
  static final UploaderService INSTANCE = new OtherUploaderService();

  @override
  void getJobs() {
  }

  @override
  void sendJob() {
  }

  @override
  void start() {
  }

  @override
  void stop() {
  }
}