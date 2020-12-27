import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tesi_simone_zanin_140833/Widgets/AvoidKeyboardWidget.dart';
import 'package:tesi_simone_zanin_140833/upload_service/UploadManager.dart';

class GeneralSettingsPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _GeneralSettingsState();

}

class _GeneralSettingsState extends State<GeneralSettingsPage> {
  
  bool bgSvcActive = true;
  bool attemptImmediately = true;

  @override
  Widget build(BuildContext context) {
    return AvoidKeyboardWidget(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Attiva servizio in background"),
                SizedBox(width: 4,),
                Switch(
                  value: bgSvcActive,
                  onChanged: (val) {
                    setState(() {
                      bgSvcActive = val;
                    });
                  },
                )
              ],
            ),
            SizedBox(height: 4,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Tenta caricamento immediatamente"),
                SizedBox(width: 4,),
                Switch(
                  value: attemptImmediately,
                  onChanged: (val) {
                    setState(() {
                      attemptImmediately = val;
                    });
                  },
                )
              ],
            ),
            SizedBox(height: 4,),
            OutlineButton(
              child: Text("Cambia configurazione server"),
              onPressed: () {
                Navigator.of(context).pushNamed("/firstConfiguration");
              },
            ),
            SizedBox(height: 4,),
            OutlineButton(
              child: Text("Effettua upload adesso"),
              onPressed: () {
                UploadManager.onUploadTaskExecuting("imagetagger.upload_from_settings");
                Scaffold.of(context).showSnackBar(SnackBar(
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.fixed,
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Upload iniziato"),
                        Icon(Icons.upload_file)
                      ],
                    ),
                  ),
                ));
              },
            ),
            SizedBox(height: 4,),
            OutlineButton(
              child: Text("Richiedi permessi di nuovo"),
              onPressed: () {
                Navigator.pushNamed(context, "/permissions");
              },
            )
          ],
        ),
      ),
    );
  }

}