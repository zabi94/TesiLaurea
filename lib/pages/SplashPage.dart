import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

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
    _checkPerms();
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

  _checkPerms() async {
    PermissionStatus _cameraStatus = await Permission.camera.status;
    PermissionStatus _locationStatus = await Permission.location.status;

    if (_cameraStatus == PermissionStatus.granted && _locationStatus == PermissionStatus.granted) {
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      Navigator.pushReplacementNamed(context, "/permissions",);
    }

  }
}