import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tesi_simone_zanin_140833/Reference.dart';
import 'package:tesi_simone_zanin_140833/Widgets/AvoidKeyboardWidget.dart';

class FirstConfigurationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FirstConfigState();

}

class _FirstConfigState extends State<FirstConfigurationPage> {

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
      appBar: AppBar(
        title: Text(Reference.appTitle),
      ),
      body: Center(
          child: _getBody(),
      ),
    );
  }

  Widget _getBody() {
    if (_loading) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20,),
          Text("Attendi")
        ],
      );
    }
    return AvoidKeyboardWidget(child: _getContent());
  }

  Widget _getContent() {
    return SingleChildScrollView(
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
              onPressed: () async {
                setState(() {
                  _loading = true;
                });
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString(Reference.prefs_server, serverFieldController.value.text);
                if (firstConfig || (passwordFieldController.text != null && passwordFieldController.text.isNotEmpty)) {
                  await prefs.setString(Reference.prefs_password, passwordFieldController.text);
                }
                await prefs.setString(Reference.prefs_username, usernameFieldController.text);
                await prefs.setBool(Reference.prefs_saved, true);
                setState(() {
                  _loading = false;
                });
                Navigator.of(context).pushReplacementNamed("/");
              },
              child: Text("Completa Configurazione"),
            ),
          )
        ],
      ),
    );
  }

}