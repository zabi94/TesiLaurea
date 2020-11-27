import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tesi_simone_zanin_140833/PersistentData.dart';
import 'package:tesi_simone_zanin_140833/Reference.dart';
import 'package:tesi_simone_zanin_140833/Widgets/TagWidget.dart';

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

  _TakePictureState(this._file) {
    var example = ["Segnaletica stradale", "Manto stradale", "Servizi fognari", "Aree verdi", "Servizi urbani", "Pulizia", "Ostacolo", "Barriera architettonica"];
    tags = List.generate(example.length, (index) => TagWidget(example[index], getTagState, onTagSelectionChanged, index));
    states = List.generate(tags.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(Reference.appTitle),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () => startUpload(context),
          )
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
    context.read<DatabaseInterface>().addPicture(copiedFile.path, controller.value.text, tagList, 0.1, 2.3);
    Navigator.of(context).pop();
    //UploaderService.getInstance().sendJob(UploadJob(getUploadId(), copiedFile.path, tagList, "description string", 0.2, 2.1));
  }

  Widget _getPageBody(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - kToolbarHeight - MediaQuery.of(context).padding.top,
      width: MediaQuery.of(context).size.width,
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