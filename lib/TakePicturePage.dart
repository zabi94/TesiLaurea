import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tesi_simone_zanin_140833/Reference.dart';
import 'package:tesi_simone_zanin_140833/Widgets/TagWidget.dart';
import 'package:transparent_image/transparent_image.dart';

class TakePicturePage extends StatefulWidget {

  PickedFile _args;

  TakePicturePage(this._args);

  @override
  State<StatefulWidget> createState() => _TakePictureState(_args);

}

class _TakePictureState extends State<TakePicturePage> {

  PickedFile _file;

  _TakePictureState(this._file);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Reference.appTitle),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.file(
                    File(_file.path)
                ),
              )
          ),
          SizedBox(height: 10,),
          Container(
            height: 30,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return _getTags(context, index);
              },
            ),
          ),
          SizedBox(height: 20,),
          OutlineButton(
            child: Text("Conferma e carica"),
          ),
          SizedBox(height: 20)
        ],
      ),
    );
  }

  Widget _getTags(BuildContext context, int index) {

    if (index.isEven) {
      return SizedBox(width: 5,);
    }

    if (index > 21) return null;

    return new TagWidget("Tag ${1 + (index ~/ 2)}", index == 0, onTagSelectionChanged);
  }

  void onTagSelectionChanged(bool state, String label) {
    print("$label is now $state");
  }

}