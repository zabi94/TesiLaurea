import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tesi_simone_zanin_140833/Widgets/DrawerGestureNavigator.dart';
import 'package:tesi_simone_zanin_140833/pages/ErrorPage.dart';
import 'package:tesi_simone_zanin_140833/pages/GalleryPage.dart';
import 'package:tesi_simone_zanin_140833/pages/GeneralSettingsPage.dart';
import 'package:tesi_simone_zanin_140833/pages/InfoPage.dart';
import '../Reference.dart';

class Homepage extends StatefulWidget {

  Homepage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  PageController _controller = new PageController(
      initialPage: 0,
  );

  String username = "", server = "";

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        username = prefs.getString(Reference.prefs_username);
        server = "${prefs.getString(Reference.prefs_server)}:${prefs.getInt(Reference.prefs_port)}";
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
          DrawerGestureNavigator(child: GalleryPage()),
          DrawerGestureNavigator(child: ErrorPage(errorMessage: "Pagina non implementata: storico")),
          DrawerGestureNavigator(child: GeneralSettingsPage()),
          DrawerGestureNavigator(child: InfoPage()),
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
                  Expanded(
                    flex: 2,
                    child: FittedBox(
                      child: Icon(Icons.person),
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(height: 2,),
                  Text(username, textScaleFactor: 1.4,),
                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.cloud_upload),
                      Text(server),
                    ],
                  ),
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
                title: Text("Cronologia caricamenti"),
                leading: Icon(Icons.history),
              ),
              onTap: () {
                _controller.jumpToPage(1);
                Navigator.of(context).pop();
              },
              splashColor: Colors.orange,
            ),
            Divider(),
            InkWell(
              child: ListTile(
                title: Text("Impostazioni"),
                leading: Icon(Icons.settings),
              ),
              onTap: () {
                _controller.jumpToPage(2);
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
                _controller.jumpToPage(3);
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