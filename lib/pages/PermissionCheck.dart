import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tesi_simone_zanin_140833/Reference.dart';

class PermissionCheck extends StatefulWidget {
  @override
  _PermissionCheckState createState() => _PermissionCheckState();
}

class _PermissionCheckState extends State<PermissionCheck> {

  PermissionStatus _storageStatus = PermissionStatus.undetermined;
  PermissionStatus _locationStatus = PermissionStatus.undetermined;
  PermissionStatus _cameraStatus = PermissionStatus.undetermined;

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
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                        "Questa app ha bisogno dei seguenti permessi per funzionare correttamente:",
                        textScaleFactor: 1.25,
                        textAlign: TextAlign.center,
                    ),
                    Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.folder_outlined),
                          trailing: _buttonIcon(_storageStatus, _reqStorage),
                          title: Text("Accesso alla memoria"),
                        ),
                        ListTile(
                          leading: Icon(Icons.gps_fixed),
                          trailing: _buttonIcon(_locationStatus, _reqLocation),
                          title: Text("Accesso alla posizione"),
                        ),
                        ListTile(
                          leading: Icon(Icons.camera_alt_outlined),
                          trailing: _buttonIcon(_cameraStatus, _reqCamera),
                          title: Text("Accesso alla fotocamera"),
                        ),
                      ],
                    ),
                    _optAndroidWarning(),

                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _optContinueButton(),
                    SizedBox(width: 10,)
                  ],
                ),
              ),
            ],
          ),
      ),
    );
  }

  Future<Null> _checkPerms() {
    return Permission.storage.status
        .then((value) {
          setState(() {
            _storageStatus = value;
          });
        })
        .then((nothing) => Permission.location.status)
        .then((value) {
          setState(() {
            _locationStatus = value;
          });
        })
        .then((nothing) => Permission.camera.status)
        .then((value) {
        setState(() {
          _cameraStatus = value;
        });
      });
  }

  Future<Null> _onInitDo() {
    return _checkPerms().then((nothing) {
      if (_storageStatus.isGranted && _locationStatus.isGranted && _cameraStatus.isGranted) {
        Navigator.of(context).pushReplacementNamed("/home", arguments: "Server name data");
      }
    });
  }


  dynamic _optContinueButton() {
    if (_storageStatus != PermissionStatus.granted || _locationStatus != PermissionStatus.granted || _cameraStatus != PermissionStatus.granted) {
      return OutlineButton(
        child: Row(
          children: [
            Text("Richiedi autorizzazioni mancanti",),
            SizedBox(width: 10,),
            Icon(Icons.assignment_turned_in_outlined)
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

  Future<Null> _reqStorage() {
    return Permission.storage.request().then((state) {
      setState(() {
        _storageStatus = state;
      });
    });
  }

  Future<Null> _reqCamera() {
    return Permission.camera.request().then((state) {
      setState(() {
        _cameraStatus = state;
      });
    });
  }

  Future<Null> _reqLocation() async {
    return Permission.location.request().then((state) {
      setState(() {
        _locationStatus = state;
      });
    });
  }

  Future<Null> _requestAllPermissions() {
    return [Permission.location, Permission.storage, Permission.camera].request()
        .then((ignore) => _checkPerms());
  }

  dynamic _optAndroidWarning() {
    if (Reference.isAndroid11) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        child: Row(
          children: [
            Icon(Icons.warning, size: 40,),
            SizedBox(width: 16,),
            Expanded(
              child: Text("Ad oggi è presente un bug nella libreria Flutter dei permessi per Android 11 e successivi.\n"
                  "Si prega di non selezionare l'opzione 'Solo questa volta' tra i permessi disponibili", textAlign: TextAlign.center,),
            ),
          ],
        ),
      );
    }
    return SizedBox(height: 0,);
  }

}