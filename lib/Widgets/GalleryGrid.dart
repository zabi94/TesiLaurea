import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tesi_simone_zanin_140833/PersistentData.dart';

class GalleryGrid extends StatefulWidget {

  GalleryGrid({Key key}) : super(key: key);

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
        images = pics.reversed.toList();
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
      addAutomaticKeepAlives: true,
      cacheExtent: 400,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 1,
        crossAxisCount: 3,
      ),
    );

  }
}

class _GalleryTile extends StatefulWidget {

  final PictureRecord _record;
  final Function _refreshSignaler;

  _GalleryTile(this._record, this._refreshSignaler, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GalleryTileState();

}

class _GalleryTileState extends State<_GalleryTile> with AutomaticKeepAliveClientMixin<_GalleryTile> {

  Image img;

  @override
  void initState() {
    super.initState();
    img = Image.file(File(widget._record.getFilePath()),
      filterQuality: FilterQuality.none,
      isAntiAlias: false,
      fit: BoxFit.cover, //Necessario per il crop centrale per evitare le bandine dell'aspect ratio non 1:1
      height: double.infinity, //Necessario per il crop centrale per evitare le bandine dell'aspect ratio non 1:1
      width: double.infinity, //Necessario per il crop centrale per evitare le bandine dell'aspect ratio non 1:1
      frameBuilder: (ctx, child, frame, immediate) {
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: _getAnimatedChild(child, frame, immediate),
        );
      },
      key: ValueKey("image_it_${widget._record.getFilePath()}"),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(img.image, context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: InkWell(
        child: img,
        onTap: () async {
          Navigator.of(context)
              .pushNamed("/gallery/showPicture", arguments: widget._record)
              .then((needsRefreshing) {
            if (needsRefreshing != null && needsRefreshing) {
              widget._refreshSignaler();
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
      height: double.infinity, //Necessario per il crop centrale per evitare le bandine dell'aspect ratio non 1:1
      width: double.infinity, //Necessario per il crop centrale per evitare le bandine dell'aspect ratio non 1:1
      alignment: Alignment.center, //Necessario per il crop centrale per evitare le bandine dell'aspect ratio non 1:1
    );
  }

  Widget _getAnimatedChild(Widget child, int frame, bool immediate) {
    if (immediate || frame != null) {
      return child;
    }
    return Center(
      child: Icon(
        Icons.hourglass_empty,
        size: 30,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

}

