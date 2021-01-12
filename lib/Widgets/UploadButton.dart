import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tesi_simone_zanin_140833/PersistentData.dart';
import 'package:tesi_simone_zanin_140833/upload_service/UploadManager.dart';

class UploadButton extends StatelessWidget {

  final String filePath;

  UploadButton(this.filePath, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.watch<DatabaseInterface>().getByPath(filePath),
      builder: (ctx, snap) {
        Widget ico = Icon(Icons.cloud, color: Colors.grey, key: UniqueKey(),);
        if (snap.hasData) {
          if (snap.data.uploadedTo != null && snap.data.uploadedTo.isNotEmpty) {
            ico = Icon(Icons.cloud_done, color: Colors.green, key: UniqueKey(),);
          } else {
            ico = Icon(Icons.cloud_upload, color: Colors.orangeAccent, key: UniqueKey(),);
          }
        }
        return InkWell(
          child: Hero(
            tag: "status-icon_$filePath",
            child: AnimatedSwitcher(
              child: ico,
              duration: Duration(milliseconds: 200),
            ),
          ),
          onTap: () {
            if (snap.hasData && (snap.data.uploadedTo == null || snap.data.uploadedTo.isEmpty)) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Caricamento"),
                duration: Duration(seconds: 1),
              ));
              UploadManager.uploadSingleJob(snap.data)
                  .catchError((err) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("Errore durante il caricamento: $err"),
                      duration: Duration(seconds: 5),
                    ));
                    return Future.error(err);
              }).then((value) {
                if (value ~/ 100 != 2) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("Caricamento fallito: $value"),
                    duration: Duration(seconds: 5),
                  ));
                } else {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("Caricamento completato: $value"),
                    duration: Duration(seconds: 5),
                  ));
                }
              });
            }
          },
        );
      },
    );
  }

}