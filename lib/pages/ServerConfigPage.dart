import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tesi_simone_zanin_140833/Reference.dart';

class ServerConfigPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ServerConfigState();

}

class _ServerConfigState extends State<ServerConfigPage> {

  TextEditingController controller_serverField = TextEditingController(
    text: "https://"
  );
  TextEditingController controller_portField = TextEditingController(
    text: "443"
  );

  bool _saving = false;

  @override
  void dispose() {
    controller_serverField.dispose();
    controller_portField.dispose();
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
                controller: controller_serverField,
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
                controller: controller_portField,
                maxLines: 1,
                autocorrect: false,
                keyboardType: TextInputType.numberWithOptions(decimal: false, signed: false),
                decoration: InputDecoration(
                    labelText: 'Inserisci la porta di destinazione'
                ),
              ),
            )
          ],
        ),
        Text("Questa pagina non è ancora funzionale. I dati immessi saranno ignorati, è possibile continuare senza cambiare il contenuto", textAlign: TextAlign.center,),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: OutlineButton(
            onPressed: () async {
              setState(() {
                _saving = true;
              });
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString(Reference.prefs_server, controller_serverField.value.text);
              await prefs.setInt(Reference.prefs_port, int.tryParse(controller_portField.value.text));
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