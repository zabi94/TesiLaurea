import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:tesi_simone_zanin_140833/PersistentData.dart';
import 'package:tesi_simone_zanin_140833/Reference.dart';
import 'package:provider/provider.dart';

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
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) {
                  return AlertDialog(
                    title: Text("Sei sicuro di voler eliminare la foto?"),
                    content: Text("Non verrà rimossa dal server su cui è stata caricata."),
                    actions: [
                      FlatButton(
                        child: Text("ANNULLA"),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                      FlatButton(
                        child: Text("CONFERMA ELIMINAZIONE"),
                        onPressed: () async {
                          await context.read<DatabaseInterface>().deletePicture(record.getFilePath());
                          Navigator.of(ctx).pop();
                          Navigator.of(ctx).pop(true);
                        },
                      )
                    ],
                  );
                }
              );
            },
            icon: Icon(Icons.delete_forever),
          ),
          IconButton(
            onPressed: () async {
              await Navigator.of(context).pushNamed("/gallery/showPicture/full", arguments: record.getFilePath()).then((value) => SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top, SystemUiOverlay.bottom]));
            },
            icon: Icon(Icons.fullscreen),
          ),
          Builder(
            builder:(newContext) {
              if (Reference.isAndroid11) return SizedBox(width: 0, height: 0,);
              return IconButton(
                onPressed: () async {
                  GallerySaver.saveImage(
                      record.getFilePath(), albumName: "ImageTagger").then((
                      value) {
                    Scaffold.of(newContext).showSnackBar(SnackBar(
                      duration: Duration(seconds: 3),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(value
                              ? "File copiato nella galleria"
                              : "Non copiato, errore sconosciuto"),
                          Icon(value ? Icons.check : Icons.error),
                        ],
                      ),
                    ));
                  });
                },
                icon: Icon(Icons.drive_file_move),
              );
            }
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 8,),
          Flexible(
            flex: 6,
            child: Center(
                child: Image.file(File(record.getFilePath()), frameBuilder: (ctx, child, frame, imm) {
                  if (imm || frame != null) {
                    return child;
                  }
                  return CircularProgressIndicator();
                },)
            )
          ),
          Expanded(
            flex: 2,
            child: Card(
              elevation: 8,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Wrap(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.start,
                          children: _mapStringsToWidgets(tags),
                          spacing: 5.0,
                        )
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                            child: Text(record.getDescription()),
                            alignment: Alignment.centerLeft,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
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