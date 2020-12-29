import 'package:flutter/material.dart';
import 'package:gallery_saver/files.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:tesi_simone_zanin_140833/Reference.dart';
import 'package:tesi_simone_zanin_140833/Widgets/AvoidKeyboardWidget.dart';
import 'package:tesi_simone_zanin_140833/upload_service/ConnectionUtils.dart';

class FirstConfigurationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FirstConfigState();

}

class _FirstConfigState extends State<FirstConfigurationPage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController serverFieldController = TextEditingController(
    text: "https://"
  );
  TextEditingController usernameFieldController = TextEditingController();
  TextEditingController passwordFieldController = TextEditingController();

  bool _loading = false;
  bool firstConfig = true;

  @override
  void dispose() {
    serverFieldController.dispose();
    usernameFieldController.dispose();
    passwordFieldController.dispose();
    super.dispose();
  }
  
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        serverFieldController.text = prefs.getString(Reference.prefs_server);
        usernameFieldController.text = prefs.getString(Reference.prefs_username);
        firstConfig = !prefs.getBool(Reference.prefs_saved);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(Reference.appTitle),
      ),
      body: Center(
          child: _getBody(),
      ),
    );
  }

  Widget _getBody() {
    return AvoidKeyboardWidget(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onEditingComplete: () {
                      //Todo check url format
                    },
                    autofocus: true,
                    enableSuggestions: false,
                    controller: serverFieldController,
                    maxLines: 1,
                    autocorrect: false,
                    keyboardType: TextInputType.url,
                    decoration: InputDecoration(
                        labelText: 'Inserisci il server di destinazione'
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    autofocus: false,
                    enableSuggestions: false,
                    controller: usernameFieldController,
                    maxLines: 1,
                    autocorrect: false,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                        labelText: 'Nome utente'
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onEditingComplete: () {
                      //Todo check port format
                    },
                    autofocus: false,
                    enableSuggestions: false,
                    controller: passwordFieldController,
                    maxLines: 1,
                    autocorrect: false,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: firstConfig?'Password':'Password (Vuoto se non modificata)'
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlineButton(
                onPressed: () => _saveConfig(context),
                child: _loading ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 60),
                  child: CircularProgressIndicator(),
                ) : Text("Salva Configurazione"),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _saveConfig(BuildContext context) {

    if (_loading) return;

    setState(() {
      _loading = true;
    });
    ConnectionUtils.probe(serverFieldController.value.text).timeout(Duration(seconds: 5), onTimeout:  () => false)
        .then((validServer) {
      if (validServer) {
        SharedPreferences.getInstance().then((prefs) {
          prefs.setString(Reference.prefs_server, serverFieldController.value.text);
          prefs.setString(Reference.prefs_username, usernameFieldController.text);
          prefs.setBool(Reference.prefs_saved, true);
          if (firstConfig || (passwordFieldController.text != null && passwordFieldController.text.isNotEmpty)) {
            prefs.setString(Reference.prefs_password, passwordFieldController.text);
          }
          setState(() {
            _loading = false;
          });
          if (firstConfig) {
            Navigator.of(context).pushReplacementNamed("/");
          } else {
            Navigator.pop(context);
          }
        });
      } else {
        setState(() {
          _loading = false;
        });
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          duration: Duration(seconds: 10),
          action: SnackBarAction(
            label: "Capito",
            onPressed: () => _scaffoldKey.currentState.removeCurrentSnackBar(),
          ),
          content: Text("Il server non è disponibile"),
        ));
      }
    });
  }

}