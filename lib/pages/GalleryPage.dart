import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tesi_simone_zanin_140833/PersistentData.dart';
import 'package:tesi_simone_zanin_140833/Widgets/EmptyScreenIndicator.dart';
import 'package:tesi_simone_zanin_140833/Widgets/GalleryTile.dart';

class GalleryPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Future<List<PictureRecord>> future = context.watch<DatabaseInterface>().getAllPictures();
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<PictureRecord> imageRecords = snapshot.data;
          if (imageRecords.isEmpty) return EmptyScreenIndicator(
            icon: Icons.upload_rounded,
            message: "Nessuna foto caricata\nAcquisisci e carica una foto per vederla qui!"
          );
          return _getCardList(imageRecords);
        }
        return _getLoadingSpinner();
      },
    );
  }

  Widget _getCardList(List<PictureRecord> imageRecords) {
    return ListView.builder(
      itemCount: imageRecords.length,
      itemBuilder: (ctx, id) => GalleryTile(imageRecords[id], key: ValueKey(imageRecords[id].getFilePath()),),
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


