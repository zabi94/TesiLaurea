import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import './Reference.dart';

class Homepage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  bool _loading = false;
  bool _empty = true;

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
    PickedFile file = await picker.getImage(source: ImageSource.camera);
    if (file != null) {
      Navigator.pushNamed(context, "/addPicture", arguments: file);
    }
  }

}