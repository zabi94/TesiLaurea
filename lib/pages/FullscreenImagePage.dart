import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class FullscreenImagePage extends StatelessWidget {

  final String imageFile;

  FullscreenImagePage(this.imageFile);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return InteractiveViewer(
      child: Image.file(File(imageFile)),
    );
  }

}