import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tesi_simone_zanin_140833/Reference.dart';

class SplashPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _SplashPageState();
  }
  
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    _checkPreconditions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Tagger"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20,),
            Text("Controllo i permessi")
          ],
        ),
      ),
    );
  }

  _checkPreconditions() async {
    PermissionStatus _cameraStatus = await Permission.camera.status;
    PermissionStatus _locationStatus = await Permission.location.status;

    if (_cameraStatus != PermissionStatus.granted || _locationStatus != PermissionStatus.granted) {
      Navigator.pushReplacementNamed(context, "/permissions",);
    } else {
      final prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey(Reference.prefs_server) || prefs.getString(Reference.prefs_server).isEmpty) {
        Navigator.pushReplacementNamed(context, "/firstConfiguration",);
      } else {
        Navigator.pushReplacementNamed(context, "/gallery", arguments: "${prefs.getString(Reference.prefs_server)}:${prefs.getInt(Reference.prefs_port)}");
      }
    }
  }
}