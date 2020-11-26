import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tesi_simone_zanin_140833/PersistentData.dart';

class GalleryPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Future<List<PictureRecord>> future = context.watch<DatabaseInterface>().getCompletedUploads();
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<PictureRecord> imageRecords = snapshot.data;
          if (imageRecords.isEmpty) return _getEmptyGridView();
          return _getGridWidget(imageRecords);
        }
        return _getLoadingSpinner();
      },
    );
  }

  Widget _getGridWidget(List<PictureRecord> imageRecords) {
    return GridView.builder(
        itemBuilder: (ctx, id) => _GalleryTile(imageRecords[id], key: ValueKey(imageRecords[id].getFilePath()),),
        itemCount: imageRecords.length,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 170,
            childAspectRatio: 1
        )
    );
  }

  Widget _getEmptyGridView() {
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

  Widget _getLoadingSpinner() {
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
}


class _GalleryTile extends StatefulWidget {

  final PictureRecord _record;

  _GalleryTile(this._record, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GalleryTileState();


}

class _GalleryTileState extends State<_GalleryTile> with AutomaticKeepAliveClientMixin<_GalleryTile> {

  Image _cachedImage;

  @override
  void initState() {
    super.initState();
    _cachedImage = Image.file(File(widget._record.getFilePath()),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: InkWell(
        child: _cachedImage,
        onTap: () async {
          Navigator.of(context).pushNamed("/gallery/showPicture", arguments: widget._record);
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
