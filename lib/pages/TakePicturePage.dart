import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tesi_simone_zanin_140833/PersistentData.dart';
import 'package:tesi_simone_zanin_140833/Reference.dart';
import 'package:tesi_simone_zanin_140833/Widgets/AvoidKeyboardWidget.dart';
import 'package:tesi_simone_zanin_140833/Widgets/BlinkingWidget.dart';
import 'package:tesi_simone_zanin_140833/Widgets/TagWidget.dart';
import 'package:tesi_simone_zanin_140833/upload_service/UploadJob.dart';
import 'package:tesi_simone_zanin_140833/upload_service/UploadManager.dart';

class TakePicturePage extends StatefulWidget {

  final PickedFile _args;

  TakePicturePage(this._args);

  @override
  State<StatefulWidget> createState() => _TakePictureState(_args);

}

class _TakePictureState extends State<TakePicturePage> {

  TextEditingController controller = TextEditingController();

  PickedFile _file;
  List<TagWidget> tags = [];
  List<bool> states = [];
  bool _gpsFixed = false;
  bool _gpsFailed = false;
  double longitude, latitude;

  _TakePictureState(this._file) {
    var example = ["Segnaletica stradale", "Manto stradale", "Servizi fognari", "Aree verdi", "Servizi urbani", "Pulizia", "Ostacolo", "Barriera architettonica"];
    tags = List.generate(example.length, (index) => TagWidget(example[index], getTagState, onTagSelectionChanged, index));
    states = List.generate(tags.length, (index) => false);
  }

  @override
  void initState() {
    super.initState();
    startNewGpsChain();
  }

  void gpsFix(Location loc, int tries) {
    if (tries == 0) {
      setState(() {
        _gpsFailed = true;
      });
    } else {
      loc.getLocation().then((location) {
        setState(() {
          longitude = location.longitude;
          latitude = location.latitude;
          _gpsFixed = true;
        });
      }).timeout(Duration(seconds: 10), onTimeout: () { gpsFix(loc, tries - 1); });
    }
  }

  void startNewGpsChain() async {
    setState(() {
      _gpsFailed = false;
      _gpsFixed = false;
    });
    Location loc = new Location();
    Future<bool> service = loc.serviceEnabled().then((enabled) {
      if (!enabled) return loc.requestService();
      return true;
    });

    service.then((actuallyEnabled) {
      if (actuallyEnabled) {
        gpsFix(loc, 3);
      } else {
        setState(() {
          _gpsFailed = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(Reference.appTitle),
        actions: _gpsFailed ? [
          IconButton(
            icon: Icon(Icons.error_outline),
            onPressed: startNewGpsChain,
          )
        ] : _gpsFixed ? [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () => startUpload(context),
          )
        ] : [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: BlinkingWidget(Duration(milliseconds: 500), Icon(Icons.gps_fixed), Icon(Icons.gps_not_fixed)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: EdgeInsets.only(bottom: keyboardSpace),
          child: _getPageBody(context),
        ),
      ),
    );
  }

  void onTagSelectionChanged(bool state, int index) {
    setState(() {
      states[index] = state;
    });
  }

  bool getTagState(int index) {
    if (index >= states.length) return false;
    return states[index];
  }

  void startUpload(BuildContext context) async {
    var tagList = tags.where((e) => states[e.index])
        .map((e) => e.label)
        .toList();
    //TODO set state to show spinner while this happens
    Directory appSuppDir = await getApplicationSupportDirectory();
    String destination = join(appSuppDir.path, "pending");
    Directory destDir = new Directory(destination);
    destDir.createSync(recursive: true);
    File photoFile = File(_file.path);
    File copiedFile = photoFile.copySync(join(destination, photoFile.path.split("/").last));
    Future<PictureRecord> dbEntry = context.read<DatabaseInterface>().addPicture(copiedFile.path, controller.value.text, tagList, latitude, longitude);
    Navigator.of(context).pop();
    SharedPreferences.getInstance()
        .then((prefs) {
          bool imm = prefs.getBool(Reference.prefs_upload_immediately);
          if (imm == null || imm) {
            dbEntry.then((entry) => UploadManager.uploadSingleJob(entry));
          }
        }
    );
  }

  Widget _getPageBody(BuildContext context) {
    return AvoidKeyboardWidget(
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.file(File(_file.path), frameBuilder: (ctx, child, frame, asynchronous) {
                      if (asynchronous || frame != null) {
                        return child;
                      }
                      return Center(child: CircularProgressIndicator(),);
                    },),
                  )
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          spacing: 2,
                          children: tags,
                          alignment: WrapAlignment.spaceEvenly,
                        ),
                      ),
                    ),
                  )
                ),
              ],
            ),
          ),
          TextField(
            decoration: InputDecoration(
                hintText: "Descrizione",
              border: OutlineInputBorder()
            ),
            controller: controller,
            maxLines: 4,
          ),
        ],
      ),
    );
  }
}