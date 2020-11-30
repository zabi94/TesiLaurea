import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FullscreenImagePage extends StatelessWidget {

  final String imageFile;

  FullscreenImagePage(this.imageFile);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: InteractiveViewer(
          child: Hero(
              transitionOnUserGestures: true,
              tag: imageFile,
              child: Image.file(File(imageFile))
          ),
          maxScale: 8,
        ),
      ),
      decoration: BoxDecoration(
        color: Color.fromARGB(200, 0, 0, 0)
      ),
    );
  }

}