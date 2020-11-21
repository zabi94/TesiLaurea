import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:tesi_simone_zanin_140833/PersistentData.dart';
import 'package:tesi_simone_zanin_140833/Reference.dart';

class GalleryPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _GalleryPageState();

}

class _GalleryPageState extends State<GalleryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Reference.appTitle),
      ),
      body: _gridView()
    );
  }

  Widget _gridView() {
    return FutureBuilder(
        future: PersistentData.getCompletedUploads(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10,),
                  Text("Caricamento galleria foto")
                ],
              ),
            );
          }

          if (snapshot.data.length == 0) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.upload_rounded, size: 80, color: Colors.black38,),
                  SizedBox(height: 20,),
                  Text("Nessuna foto caricata"),
                  Text("Acquisisci e carica una foto per vederla qui!")
                ],
              ),
            );
          }

          return GridView.builder(
            itemBuilder: (ctx, id) => _buildGrid(ctx, id, snapshot.data),
            itemCount: snapshot.data.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1,
              crossAxisCount: 3,
            ),
          );
        });
  }

  Widget _buildGrid(BuildContext ctx, int index, List<PictureRecord> data) {
    return FutureBuilder(
      future: PersistentData.getCompletedUploads(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            String file = snapshot.data[index].getFilePath();
            return Container(
              child: InkWell(
                child: Image.file(File(file)),
                onTap: () {},
                splashColor: Colors.orange,
              ),
              decoration: BoxDecoration(
                border: BorderDirectional(
                  bottom: BorderSide(
                      width: 1,
                      color: Colors.black12,
                      style: BorderStyle.solid
                  ),
                  end: BorderSide(
                      width: 1,
                      color: Colors.black12,
                      style: BorderStyle.solid
                  ),
                ),
              ),
            );
          } else {
            return Center(
                child: CircularProgressIndicator()
            );
          }
        }
      ,
    );
  }
}