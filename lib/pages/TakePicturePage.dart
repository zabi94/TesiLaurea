import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tesi_simone_zanin_140833/Reference.dart';
import 'package:tesi_simone_zanin_140833/Widgets/TagWidget.dart';

class TakePicturePage extends StatefulWidget {

  final PickedFile _args;

  TakePicturePage(this._args);

  @override
  State<StatefulWidget> createState() => _TakePictureState(_args);

}

class _TakePictureState extends State<TakePicturePage> {

  PickedFile _file;
  List<TagWidget> tags = [];
  List<bool> states = [];

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
            onPressed: () {
              print("Tag abilitati:");
              tags.where((e) => states[e.index])
                  .map((e) => e.label)
                  .forEach((e) {
                    print(e);
                  });
            },
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

    if (index > 31) return null;

    int tagIndex = 1 + (index ~/ 2);

    while (tags.length <= tagIndex) {
      states.add(false);
      tags.add(new TagWidget("Tag ${tags.length}", getTagState, onTagSelectionChanged, tags.length));
    }

    return tags[tagIndex];
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

}