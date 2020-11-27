import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FullscreenImagePage extends StatelessWidget {

  final String imageFile;

  FullscreenImagePage(this.imageFile);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return InteractiveViewer(
      child: Hero(
          transitionOnUserGestures: true,
          tag: imageFile,
          child: Image.file(File(imageFile))
      ),
      maxScale: 8,
    );
  }

}