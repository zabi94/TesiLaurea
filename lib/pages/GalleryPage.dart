import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tesi_simone_zanin_140833/Reference.dart';
import 'package:tesi_simone_zanin_140833/Widgets/GalleryGrid.dart';

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
      body: GalleryGrid()
    );
  }

}