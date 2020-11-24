import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tesi_simone_zanin_140833/PersistentData.dart';

class GalleryGrid extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _GalleryState();

}

class _GalleryState extends State<GalleryGrid> {

  List<PictureRecord> images;

  @override
  void initState() {
    super.initState();
    reloadPictures();
  }

  void reloadPictures() async {
    setState(() {
      images = null;
    });
    await PersistentData.getCompletedUploads().then((pics) {
      setState(() {
        images = pics;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (images == null) {
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
    if (images.length == 0) {
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
      itemBuilder: (ctx, id) => _GalleryTile(images[id], reloadPictures, key: GlobalKey()),
      itemCount: images.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 1,
        crossAxisCount: 3,
      ),
    );

  }
}

class _GalleryTile extends StatelessWidget {

  final PictureRecord _record;
  final Function _refreshSignaler;

  _GalleryTile(this._record, this._refreshSignaler, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        child: Image.file(File(_record.getFilePath()), filterQuality: FilterQuality.none, isAntiAlias: false, frameBuilder: (ctx, child, frame, immediate) {
          if (immediate || frame != null) {
            return child;
          }
          return Center(child: CircularProgressIndicator(),);
        },),
        onTap: () async {
          Navigator.of(context)
              .pushNamed("/gallery/showPicture", arguments: _record)
              .then((needsRefreshing) {
            if (needsRefreshing != null && needsRefreshing) {
              _refreshSignaler();
            }
          });
        },
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
  }
}

