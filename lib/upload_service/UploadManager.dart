import 'dart:convert';

import 'package:background_fetch/background_fetch.dart' as bg;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tesi_simone_zanin_140833/PersistentData.dart';
import 'package:tesi_simone_zanin_140833/Reference.dart';
import 'package:tesi_simone_zanin_140833/upload_service/UploadJob.dart';

class UploadManager {

  static Future<int> _uploadPending(String id) async {
    int completedSuccesfully = 0;
    String destinationUrl = await _getUploadUrl();
    List<UploadJob> jobs = (await DatabaseInterface.instance.getPendingUploads())
        .map((e) => UploadJob(e.rowid, e.getFilePath(), jsonDecode(e.getJsonTags(), reviver: _toStringList), e.getDescription(), e.getLatitude(), e.getLongitude())).toList();

    List<Future<bool>> futures = jobs.map((j) => _performUploadJob(j)
        .then((response) {
          if (response ~/ 100 == 2) {
            return DatabaseInterface.instance.complete(j, destinationUrl);
          } else {
            print("Error: status code was $response from $destinationUrl");
            return Future.value(false);
          }
        })
        .then((value) { if (value) {completedSuccesfully++; }  return value;})
    ).toList();

    return Future.wait(futures)
        .whenComplete(() {
          print("Completed $completedSuccesfully job(s) out of ${jobs.length}");
          bg.BackgroundFetch.finish(id);
        })
        .then((value) => Future.value(completedSuccesfully));
  }

  static Future<int> uploadSingleJob(PictureRecord e) {
    UploadJob job = UploadJob(e.rowid, e.getFilePath(), jsonDecode(e.getJsonTags(), reviver: _toStringList), e.getDescription(), e.getLatitude(), e.getLongitude());
    return _performUploadJob(job);
  }
  
  static Future<int> _performUploadJob(UploadJob j) {
    return _getUploadUrl().then((destinationUrl) => http.post(destinationUrl, body: j.getAsJson(), headers: {"Content-Type": "application/json"})
        .catchError((err) {
          print("Error getting http response:\n$err");
          return Future.value(false);
        })
        .then((response) => DatabaseInterface.instance.complete(j, destinationUrl).then((value) => response.statusCode))
    );
  }
  
  static Future<String> _getUploadUrl() async {
    return "${(await SharedPreferences.getInstance()).getString(Reference.prefs_server)}/upload";
  }

  static Object _toStringList(Object index, Object list) {
    if (index != null) return list;
    List<dynamic> dynlist = list as List<dynamic>;
    return dynlist.map((e) => e.toString()).toList();
  }

  static void _enableBackgroundTasks() {
    bg.BackgroundFetch.configure(
        bg.BackgroundFetchConfig(
            minimumFetchInterval: 15,
            enableHeadless: true,
            startOnBoot: true,
            requiredNetworkType: bg.NetworkType.UNMETERED,
            stopOnTerminate: false,
            requiresStorageNotLow: false,
            requiresBatteryNotLow: true,
            requiresCharging: false,
            requiresDeviceIdle: false,
            forceAlarmManager: true
        ), onUploadTaskExecuting,
    );
    bg.BackgroundFetch.registerHeadlessTask(scheduleNextUpload);
  }

  static void _disableBackgroundTasks() {
    bg.BackgroundFetch.configure(
      bg.BackgroundFetchConfig(
          minimumFetchInterval: 15,
          enableHeadless: false,
          startOnBoot: false,
          requiredNetworkType: bg.NetworkType.UNMETERED,
          stopOnTerminate: true,
          requiresStorageNotLow: false,
          requiresBatteryNotLow: true,
          requiresCharging: false,
          requiresDeviceIdle: false,
          forceAlarmManager: true
      ), onUploadTaskExecuting,
    );
  }

  static void setupTasks() {
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getBool(Reference.prefs_bg_enabled) || false) {
        _enableBackgroundTasks();
      } else {
        _disableBackgroundTasks();
      }
    });
  }

  static void onUploadTaskExecuting(String id) async {
    print("Starting non-fetch upload task: $id");
    UploadManager._uploadPending(id);
  }

  static void scheduleNextUpload(String id) {
    print("Automatic background task received: $id");
    if (id == 'flutter_background_fetch') {
      bg.BackgroundFetch.scheduleTask(bg.TaskConfig(
          taskId: "imageTagger.uploadTask@${DateTime.now().toString()}",
          periodic: false,
          delay: 0,
          stopOnTerminate: false,
          enableHeadless: true
      ));
    }
    bg.BackgroundFetch.finish(id);
  }

}