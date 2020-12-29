import 'package:shared_preferences/shared_preferences.dart';
import 'package:tesi_simone_zanin_140833/Reference.dart';
import 'package:http/http.dart' as http;

class ConnectionUtils {

  static Future<bool> heartbeat() {
    return getEndpoint().then((endpoint) => http.head("$endpoint/heartbeat"))
        .then((value) {
          print("Heartbeat to ${value.request.url.toString()} was ${value.statusCode}");
          return value.statusCode == 204;
        });
  }

  static Future<String> getEndpoint() {
    return SharedPreferences.getInstance().then((p) => p.getString(Reference.prefs_server));
  }

  static Future<bool> probe(String endpoint) {
    return Future.value(
        http.head("$endpoint/heartbeat")
            .then((value) {
          print("Probe to ${value.request.url.toString()} was ${value.statusCode}");
          return value.statusCode == 204;
        })
    ).timeout(Duration(seconds: 5), onTimeout: () => false)
    .catchError((err) {
      print("Error probing $endpoint: $err");
      return false;
    });
  }

}