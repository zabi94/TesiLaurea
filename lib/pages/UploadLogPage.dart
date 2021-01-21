import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tesi_simone_zanin_140833/PersistentData.dart';
import 'package:tesi_simone_zanin_140833/Widgets/EmptyScreenIndicator.dart';

class UploadLogPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.watch<UploadListWatcher>().getUploads(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 64,),
                SizedBox(height: 16,),
                Text("Errore nell'apertura del registro!"),
                SizedBox(height: 16,),
                Text(snapshot.error.toString()),
              ],
            ),
          );
        }
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return ListView.builder(
              itemCount: snapshot.data.length ,
              itemBuilder: (context, index) {
                return UploadTile(snapshot.data[index]);
              },
            );
          } else {
            return EmptyScreenIndicator(
              icon: Icons.all_inbox,
              message: "Nessun upload effettuato.",
            );
          }
        } else {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16,),
                Text("Caricamento registro in corso")
              ],
            ),
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
            Expanded(
              flex: 2,
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.file(
                    File(record.filePath),
                    frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                      if (wasSynchronouslyLoaded || frame == 0) return child;
                      return Icon(Icons.timer);
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error, color: Colors.red,);
                    },
                    fit: BoxFit.cover, //Necessario per il crop centrale per evitare le bandine dell'aspect ratio non 1:1
                    height: double.infinity, //Necessario per il crop centrale per evitare le bandine dell'aspect ratio non 1:1
                    width: double.infinity, //Necessario per il crop centrale per evitare le bandine dell'aspect ratio non 1:1
                ),
              ),
            ),
            SizedBox(width: 10,),
            Expanded(
              flex: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Upload #${record.upload_id}", textScaleFactor: 1.15,),
                  SizedBox(height: 5,),
                  Text("User: ${record.user}", maxLines: 1, overflow: TextOverflow.fade,),
                  Text("Data: ${record.time.day}/${record.time.month}/${record.time.year}, ${record.time.hour}:${record.time.minute}", maxLines: 1, overflow: TextOverflow.fade,),
                  Text("Server: ${record.server}",)
                ],
              ),
            ),
            SizedBox(width: 10,),
            Expanded(
              flex: 1,
              child: record.isSuccessful()
                  ? Icon(Icons.check, color: Colors.green,)
                  : IconButton(
                icon: Icon(Icons.open_in_new, color: Colors.red,),
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