import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tesi_simone_zanin_140833/Reference.dart';
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
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      bool svc = prefs.getBool(Reference.prefs_bg_enabled);
      bool imm = prefs.getBool(Reference.prefs_upload_immediately);
      setState(() {
        bgSvcActive = svc == null ? true : svc;
        attemptImmediately =  imm == null ? true : imm;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AvoidKeyboardWidget(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
                      SharedPreferences.getInstance().then((prefs) {
                        prefs.setBool(Reference.prefs_bg_enabled, bgSvcActive);
                      }).then((value) => UploadManager.setupTasks());
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
                      SharedPreferences.getInstance().then((prefs) {
                        prefs.setBool(Reference.prefs_upload_immediately, attemptImmediately);
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
                child: Text("Riavvia procedura permessi"),
                onPressed: () {
                  Navigator.pushNamed(context, "/permissions");
                },
              )
            ],
          ),
        ),
      ),
    );
  }

}