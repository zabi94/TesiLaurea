import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tesi_simone_zanin_140833/PersistentData.dart';
import 'package:tesi_simone_zanin_140833/upload_service/UploadJob.dart';

class UploadManager {

  static Future<int> uploadPending(String id, String destinationUrl) async {
    int completedSuccesfully = 0;
    List<UploadJob> jobs = (await DatabaseInterface.instance.getPendingUploads())
        .map((e) => UploadJob(e.rowid, e.getFilePath(), jsonDecode(e.getJsonTags(), reviver: _toStringList), e.getDescription(), e.getLatitude(), e.getLongitude())).toList();

    List<Future<bool>> futures = jobs.map((j) => http.post(destinationUrl, body: j.getAsJson(), headers: {"Content-Type": "application/json"})
        .then((response) {
          if (response.statusCode ~/ 100 == 2) {
            return DatabaseInterface.instance.complete(j, destinationUrl);
          } else {
            print("Error: status code was ${response.statusCode} from $destinationUrl");
            return Future.value(false);
          }
        })
        .then((value) { if (value) {completedSuccesfully++; }  return value;})
    ).toList();

    return Future.wait(futures).whenComplete(() => print("Completed $completedSuccesfully job(s) out of ${jobs.length}"))
    .then((value) => Future.value(completedSuccesfully));
  }

  static Object _toStringList(Object index, Object list) {
    if (index != null) return list;
    List<dynamic> dynlist = list as List<dynamic>;
    return dynlist.map((e) => e.toString()).toList();
  }

}