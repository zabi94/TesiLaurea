import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionCheck extends StatefulWidget {
  @override
  _PermissionCheckState createState() => _PermissionCheckState();
}

class _PermissionCheckState extends State<PermissionCheck> {

  PermissionStatus _cameraStatus = PermissionStatus.undetermined;
  PermissionStatus _locationStatus = PermissionStatus.undetermined;

  @override
  void initState() {
    super.initState();
    _onInitDo();
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
              Expanded(
                child: SizedBox(height: 10,),
              ),
              Text(
                  "Questa app ha bisogno dei seguenti permessi:",
                  style: Theme.of(context).textTheme.bodyText2.apply(fontSizeFactor: 1.1)
              ),
              SizedBox(height: 50,),
              ListTile(
                leading: Icon(Icons.camera),
                trailing: _buttonIcon(_cameraStatus, _reqCamera),
                title: Text("Utilizzo della fotocamera"),
              ),
              ListTile(
                leading: Icon(Icons.gps_fixed),
                trailing: _buttonIcon(_locationStatus, _reqLocation),
                title: Text("Utilizzo della posizione"),
              ),
              SizedBox(height: 100,),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _optContinueButton(),
                    SizedBox(width: 10,)
                  ],
                ),
              )
            ],
          )
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _checkPerms() async {
    _cameraStatus = await Permission.camera.status;
    _locationStatus = await Permission.location.status;
  }

  _onInitDo() async {
    await _checkPerms();
    if (_cameraStatus.isGranted && _locationStatus.isGranted) {
      Navigator.of(context).pushReplacementNamed("/home");
    }
  }


  _optContinueButton() {
    if (_cameraStatus != PermissionStatus.granted || _locationStatus != PermissionStatus.granted) {
      return OutlineButton(
        child: Row(
          children: [
            Text("Richiedi autorizzazioni mancanti", style: Theme.of(context).textTheme.bodyText2.apply(color: Colors.red),),
            SizedBox(width: 10,),
            Icon(Icons.error, color: Colors.red,)
          ],
        ),
        onPressed: _requestAllPermissions,
      );
    }

    return OutlineButton(
      child: Row(
        children: [
          Text("Continuiamo"),
          SizedBox(width: 10,),
          Icon(Icons.arrow_forward_rounded)
        ],
      ),
      onPressed: () {
        Navigator.of(context).pushReplacementNamed("/");
      },
    );
  }

  _buttonIcon(PermissionStatus ps, Function onPress) {
    if (ps == PermissionStatus.granted) {
      return Icon(
        Icons.check,
        color: Colors.green,
      );
    } else if (ps == PermissionStatus.permanentlyDenied || ps == PermissionStatus.restricted) {
      return Icon(
        Icons.error_outline,
        color: Colors.red,
      );
    } else {
      return Tooltip(
        message: ps.toString(),
        child: OutlineButton(
          child: Text("Richiedi"),
          onPressed: onPress,
        ),
      );
    }
  }

  _reqCamera() async {
    var newstate = await Permission.camera.request();
    setState(() {
      _cameraStatus = newstate;
    });
  }

  _reqLocation() async {
    var newstate = await Permission.location.request();
    setState(() {
      _locationStatus = newstate;
    });
  }
  _requestAllPermissions() async {
    var states = await [Permission.location, Permission.camera].request();
    await _checkPerms(); //Necessario per garantire la corretta lettura dei permessi, essendo una doppia richiesta potrebbe riportarne i valori incorrettamente
    setState(() {
      _checkPerms();
    });

  }

}