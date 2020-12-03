import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tesi_simone_zanin_140833/PersistentData.dart';
import 'package:tesi_simone_zanin_140833/Widgets/GalleryTile.dart';

class GalleryPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Future<List<PictureRecord>> future = context.watch<DatabaseInterface>().getCompletedUploads();
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity > 0) {
          Scaffold.of(context).openDrawer();
        }
      },
      child: FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<PictureRecord> imageRecords = snapshot.data;
            if (imageRecords.isEmpty) return _getEmptyGridView();
            return _getCardList(imageRecords);
          }
          return _getLoadingSpinner();
        },
      ),
    );
  }

  Widget _getCardList(List<PictureRecord> imageRecords) {
    return ListView.builder(
      itemCount: imageRecords.length,
      itemBuilder: (ctx, id) => GalleryTile(imageRecords[id], key: ValueKey(imageRecords[id].getFilePath()),),
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


