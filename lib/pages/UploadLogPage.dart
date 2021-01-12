import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tesi_simone_zanin_140833/PersistentData.dart';

class UploadLogPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.watch<UploadListWatcher>().getUploads(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length ,
            itemBuilder: (context, index) {
              return UploadTile(snapshot.data[index]);
            },
          );
        } else {
          return Center(
            child: Text("Caricamento registro..."),
          );
        }
      },
    );
  }
}

class UploadTile extends StatelessWidget {

  final UploadRecord record;

  UploadTile(this.record);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            record.isSuccessful()
                ? Icon(Icons.check)
                : Icon(Icons.error_outline),
            SizedBox(width: 18,),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Upload #${record.upload_id} per l'immagine ${record.picture_id}", textScaleFactor: 1.1,),
                  SizedBox(height: 5,),
                  Text("User: ${record.user}", maxLines: 1, overflow: TextOverflow.fade,),
                  Text("Data: ${record.time}", maxLines: 1, overflow: TextOverflow.fade,),
                  Text("Server: ${record.server}",)
                ],
              ),
            ),
            SizedBox(width: 18,),
            record.isSuccessful() ? SizedBox(width: 1, height: 1,) : IconButton(
              icon: Icon(Icons.open_in_new),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Dettagli errore"),
                        actions: [
                          TextButton(
                            child: Text("OK"),
                            onPressed: () => Navigator.pop(context),
                          )
                        ],
                        content: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(record.result),
                            SizedBox(height: 20,),
                            Text(getStatusCodeDescription(record.statusCode)),
                          ],
                        ),
                      );
                    }
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String getStatusCodeDescription(int code) {
    switch (code) {
      case -1: return "Transazione HTTP non effettuata";
      case 401: return "Nome utente/Password non accettate dal server (401)";
      case 404: return "Server incorretto, risorsa non trovata (404)";
      case 200:case 204: return "Transazione completata con successo";
      default:
        {
          int codeFamily = code ~/ 100;
          switch (codeFamily) {
            case 5: return "Errore del server: $code";
            case 4: return "Errore nella richiesta: $code";
            default: return "Codice non riconosciuto: $code";
          }
        }
    }
  }

}