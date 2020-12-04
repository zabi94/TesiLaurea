import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tesi_simone_zanin_140833/Reference.dart';

class ServerConfigPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ServerConfigState();

}

class _ServerConfigState extends State<ServerConfigPage> {

  TextEditingController serverFieldController = TextEditingController(
    text: "https://"
  );
  TextEditingController portFieldController = TextEditingController(
    text: "443"
  );

  bool _saving = false;

  @override
  void dispose() {
    serverFieldController.dispose();
    portFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Reference.appTitle),
      ),
      body: Center(
        child: _getBodyForState()
      ),
    );
  }

  Widget _getBodyForState() {
    if (_saving) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20,),
          Text("Salvataggio in corso")
        ],
      );
    }
    return _getContent();
  }

  Widget _getContent() {
    return Column(
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
                onEditingComplete: () {
                  //Todo check port format
                },
                autofocus: false,
                enableSuggestions: false,
                controller: portFieldController,
                maxLines: 1,
                autocorrect: false,
                keyboardType: TextInputType.numberWithOptions(decimal: false, signed: false),
                decoration: InputDecoration(
                    labelText: 'Inserisci la porta di destinazione'
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
                _saving = true;
              });
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString(Reference.prefs_server, serverFieldController.value.text);
              await prefs.setInt(Reference.prefs_port, int.tryParse(portFieldController.value.text));
              setState(() {
                _saving = false;
              });
              Navigator.of(context).pushReplacementNamed("/");
            },
            child: Text("Completa Configurazione"),
          ),
        )
      ],
    );
  }

}