import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Reference.dart';

class Homepage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  bool _loading = false;
  bool _empty = true;
  bool _gettingImage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Reference.appTitle),
      ),
      body: Center(
        child: _showSpinner()
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _takePicture,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.orange,
                    Colors.orangeAccent
                  ]
                )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.label, size: 80,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Image Tagger", style: TextStyle(
                        fontSize: 20.0
                      )
                    ),
                  )
                ],
              )
            ),
            InkWell(
              child: ListTile(
                title: Text("Homepage"),
                leading: Icon(Icons.home),
                trailing: Icon(Icons.arrow_right),
              ),
              onTap: () => {},
              splashColor: Colors.orange,
            ),
            Divider(),
            InkWell(
              child: ListTile(
                title: Text("Impostazioni"),
                leading: Icon(Icons.settings),
                trailing: Icon(Icons.arrow_right),
              ),
              onTap: () => {},
              splashColor: Colors.orange,
            ),
            Divider(),
            InkWell(
              child: ListTile(
                title: Text("Informazioni"),
                leading: Icon(Icons.info_outline),
                trailing: Icon(Icons.arrow_right),
              ),
              onTap: () => {Navigator.of(context).pushNamed("/info")},
              splashColor: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  _showSpinner() {
    if (_loading) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20,),
          Text("Caricamento dati")
        ],
      );
    }

    if (_gettingImage) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20,),
          Text("Acquisiszione foto")
        ],
      );
    }

    if (_empty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.all_inbox, size: 80, color: Colors.black38,),
          SizedBox(height: 20,),
          Text("Nessun dato presente"),
          Text("Clicca sul pulsante + per iniziare")
        ],
      );
    }

    return ListView.builder(itemBuilder: (context, index) {
      return ListTile(
        title: Text("Hello"),
      );
    },);
  }

  _takePicture() async {
    ImagePicker picker = ImagePicker();
    setState(() {
      _gettingImage = true;
    });
    PickedFile file = await picker.getImage(source: ImageSource.camera);
    setState(() {
      _gettingImage = false;
    });
    if (file != null) {
      Navigator.pushNamed(context, "/addPicture", arguments: file);
    }
  }

}