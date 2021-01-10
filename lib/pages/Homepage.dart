import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tesi_simone_zanin_140833/PersistentData.dart';
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


  @override
  void initState() {
    super.initState();
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
                  FutureBuilder(
                    future: context.watch<SettingsInterface>().getUser(),
                    builder: (ctx, snap) {
                      if (snap.hasData) {
                        return Text(snap.data, textScaleFactor: 1.4, maxLines: 1, overflow: TextOverflow.ellipsis,);
                      }
                      return Text("Caricamento...");
                    },
                  ),
                  SizedBox(height: 15,),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.cloud_upload),
                        SizedBox(width: 10,),
                        FutureBuilder(
                          future: context.watch<SettingsInterface>().getServer(),
                          builder: (ctx, snap) {
                            if (snap.hasData) {
                              return Text(snap.data, textScaleFactor: 1.4, maxLines: 1, overflow: TextOverflow.ellipsis,);
                            }
                            return Text("Caricamento...");
                          },
                        ),
                      ],
                    ),
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