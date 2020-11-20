import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tesi_simone_zanin_140833/pages/GalleryPage.dart';
import 'package:tesi_simone_zanin_140833/pages/Homepage.dart';
import 'package:tesi_simone_zanin_140833/pages/InfoPage.dart';
import 'package:tesi_simone_zanin_140833/pages/PermissionCheck.dart';
import 'package:tesi_simone_zanin_140833/pages/ServerConfigPage.dart';
import 'package:tesi_simone_zanin_140833/pages/SplashPage.dart';
import 'package:tesi_simone_zanin_140833/pages/TakePicturePage.dart';

import 'pages/ErrorPage.dart';

void main() {
  runApp(AppContainer());
}

class AppContainer extends StatelessWidget with WidgetsBindingObserver {

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      //TODO ricontrolla permessi
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Image Tagger",
      theme: ThemeData(
        primaryColor: Colors.orange,
      ),
      initialRoute: "/",
      onGenerateRoute: (settings) {

        String args = "Errore generico";

        if (settings.arguments is String) {
          args = settings.arguments;
        }

        print("Switching to ${settings.name}");

        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => SplashPage());
          case '/permissions':
            return MaterialPageRoute(builder: (context) => PermissionCheck());
          case '/home':
            if (!(settings.arguments is String)) {
              return MaterialPageRoute(builder: (context) => ErrorPage(errorMessage: "/home expects the server name"));
            }
            String args = settings.arguments;
            return MaterialPageRoute(builder: (context) => Homepage(args));
          case '/info':
            return MaterialPageRoute(builder: (context) => InfoPage());
          case '/firstConfiguration':
            return MaterialPageRoute(builder: (context) => ServerConfigPage());
          case '/gallery':
            return MaterialPageRoute(builder: (context) => GalleryPage());
          case '/addPicture':
            if (settings.arguments is PickedFile) {
              return MaterialPageRoute(builder: (context) => TakePicturePage(settings.arguments));
            }
            return MaterialPageRoute(builder: (context) => ErrorPage(errorMessage: "/addPicture expects PickedFile data"));
          default:
            return MaterialPageRoute(builder: (context) => ErrorPage(errorMessage: args));
        }
      },
    );
  }

}
