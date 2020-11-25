import 'package:flutter/material.dart';
import 'package:tesi_simone_zanin_140833/Reference.dart';
import 'package:tesi_simone_zanin_140833/Widgets/GalleryGrid.dart';
import 'package:image_picker/image_picker.dart';

class GalleryPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _GalleryPageState();

}

class _GalleryPageState extends State<GalleryPage> with AutomaticKeepAliveClientMixin<GalleryPage> {

  int changes = 0;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(Reference.appTitle),
      ),
      body: GalleryGrid(key: ValueKey(changes)),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _takePicture,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
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
                      child: Row(
                        children: [
                          Icon(Icons.check),
                          SizedBox(width: 10,),
                          Text("[[Info connessione qui]]"),
                        ],
                      ),
                    )
                  ],
                )
            ),
            InkWell(
              child: ListTile(
                title: Text("Caricamenti (WIP)"),
                leading: Icon(Icons.upload_rounded),
              ),
              onTap: () {},
              splashColor: Colors.orange,
            ),
            Divider(),
            InkWell(
              child: ListTile(
                title: Text("Impostazioni (WIP)"),
                leading: Icon(Icons.settings),
              ),
              onTap: () => {},
              splashColor: Colors.orange,
            ),
            Divider(),
            InkWell(
              child: ListTile(
                title: Text("Informazioni"),
                leading: Icon(Icons.info_outline),
              ),
              onTap: () => Navigator.of(context).pushNamed("/info"),
              splashColor: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  _takePicture() async {
    PickedFile file = await ImagePicker().getImage(source: ImageSource.camera);
    if (file != null) {
      Navigator.pushNamed(context, "/addPicture", arguments: file).then((pictureTaken) {
        if (pictureTaken != null && pictureTaken) {
          setState(() {
            changes++;
          });
        }
      });
    }
  }

  @override
  bool get wantKeepAlive => true;

}