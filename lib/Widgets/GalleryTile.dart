import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tesi_simone_zanin_140833/PersistentData.dart';

class GalleryTile extends StatefulWidget {

  final PictureRecord _record;

  GalleryTile(this._record, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GalleryTileState();

}

class _GalleryTileState extends State<GalleryTile> {

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
    List<Widget> chips = widget._record.getChipTags();
    return Container(
      constraints: BoxConstraints(
          maxHeight: 250
      ),
      child: Card(
        child: InkWell(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Hero(
                            tag: widget._record.getFilePath(),
                            child: _cachedImage
                        ),
                      ),
                      constraints: BoxConstraints(
                          maxHeight: 170
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget._record.getDescription(), maxLines: 8, overflow: TextOverflow.fade,),
                      ),
                    ),
                    FutureBuilder(
                      future: context.watch<DatabaseInterface>().getByPath(widget._record.getFilePath()),
                      builder: (ctx, snap) {
                        Widget wid = Icon(Icons.cloud, color: Colors.grey, key: UniqueKey(),);
                        if (snap.hasData) {
                          String uploadedTo = snap.data.uploadedTo;
                          wid = Icon(Icons.cloud_upload, color: Colors.orangeAccent, key: UniqueKey(),);
                          if (uploadedTo != null && uploadedTo.isNotEmpty) {
                            wid = Icon(Icons.cloud_done, color: Colors.green, key: UniqueKey());
                          }
                        }
                        return Hero(
                          tag: "status-icon_${widget._record.getFilePath()}",
                          child: AnimatedSwitcher(
                            child: wid,
                            duration: Duration(milliseconds: 200),
                          ),
                        );
                      },
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.start,
                ),
              ),
              Expanded(
                  child: chips.isEmpty ? Center(child: Text("Nessun tag", textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText2.apply(fontStyle: FontStyle.italic, ))) : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                        children: List.generate(chips.length * 2, (i) {
                          if (i%2==0) return SizedBox(width: 8,);
                          return chips[i~/2];
                        })
                    ),
                  )
              ),
            ],
          ),
          onTap: () => Navigator.of(context).pushNamed("/gallery/showPicture", arguments: widget._record),
          splashColor: Colors.orange,
        ),
      ),
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

}
