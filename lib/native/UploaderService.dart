import 'dart:io';

import 'package:flutter/services.dart';
import 'package:tesi_simone_zanin_140833/native/UploadJob.dart';

abstract class UploaderService {

  static UploaderService getInstance() {
    if (Platform.isAndroid) {
      return AndroidUploaderService.INSTANCE;
    }
    return OtherUploaderService.INSTANCE;
  }

  void start();
  void stop();
  void sendJob(UploadJob job);
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
  void sendJob(UploadJob job) async {
    String s = await channel.invokeMethod("add", job.getAsJson());
    s.split(",").forEach((element) => print(element));
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
  void sendJob(UploadJob job) {
  }

  @override
  void start() {
  }

  @override
  void stop() {
  }
}