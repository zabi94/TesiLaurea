import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tesi_simone_zanin_140833/pages/GalleryPage.dart';
import 'package:tesi_simone_zanin_140833/pages/InfoPage.dart';
import '../Reference.dart';

class Homepage extends StatefulWidget {

  final String server;

  Homepage(this.server, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  PageController _controller = new PageController(
      initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Reference.appTitle),

      ),
      body: PageView(
        controller: _controller,
        physics: NeverScrollableScrollPhysics(),
        children: [
          GalleryPage(),
          InfoPage()
        ],
      ),
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
                  Icon(Icons.label, size: 50,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("[[Info server qui]]"),
                  )
                ],
              )
            ),
            InkWell(
              child: ListTile(
                title: Text("Galleria"),
                leading: Icon(Icons.image),
              ),
              onTap: () {
                _controller.jumpToPage(0);
                Navigator.of(context).pop();
              },
              splashColor: Colors.orange,
            ),
            Divider(),
            InkWell(
              child: ListTile(
                title: Text("Informazioni"),
                leading: Icon(Icons.info_outline),
              ),
              onTap: () {
                _controller.jumpToPage(1);
                Navigator.of(context).pop();
              },
              splashColor: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  _takePicture() async {
    ImagePicker picker = ImagePicker();
    PickedFile file = await picker.getImage(source: ImageSource.camera);
    if (file != null) {
      Navigator.pushNamed(context, "/addPicture", arguments: file);
    }
  }

}