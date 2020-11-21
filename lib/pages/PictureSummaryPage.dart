import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tesi_simone_zanin_140833/PersistentData.dart';
import 'package:tesi_simone_zanin_140833/Reference.dart';

class PictureSummaryPage extends StatelessWidget {

  final PictureRecord record;

  PictureSummaryPage(this.record);

  @override
  Widget build(BuildContext context) {
    var tags = jsonDecode(record.getJsonTags());
    return Scaffold(
      appBar: AppBar(
        title: Text(Reference.appTitle),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.delete_forever),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.fullscreen),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.drive_file_move),
        onPressed: () {},
      ),
      body: Column(
        children: [
          Image.file(File(record.getFilePath())),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.start,
                  children: _mapStringsToWidgets(tags),
                  spacing: 5.0,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(record.getDescription(),textAlign: TextAlign.left,),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //Necessaria per la conversione esplicita del dynamic in String
  List<Widget> _mapStringsToWidgets(List<dynamic> list) {
    var result = <Widget>[];
    for (int i = 0; i < list.length; i++) {
      String s = list[i].toString();
      result.add(Chip(label: Text(s)));
    }
    return result;
  }

}