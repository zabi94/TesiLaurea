import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
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
      body: GridView.builder(
        itemCount: 70,
        itemBuilder: _buildGrid,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1,
          crossAxisCount: 3,
        ),
      ),
    );
  }

  Widget _buildGrid(BuildContext ctx, int index) {
    return FutureBuilder(
      future: getApplicationSupportDirectory(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            int incrementalId = 0; //TODO uniquely identify pictures. By datetime maybe? From database index?
            String file = join(snapshot.data.path, "pending", "$incrementalId", "image.png");
            return Image.file(File(file));
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