import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tesi_simone_zanin_140833/Homepage.dart';
import 'package:tesi_simone_zanin_140833/PermissionCheck.dart';
import 'package:tesi_simone_zanin_140833/SplashPage.dart';
import 'package:tesi_simone_zanin_140833/TakePicturePage.dart';

import './ErrorPage.dart';

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

        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => SplashPage());
          case '/permissions':
            return MaterialPageRoute(builder: (context) => PermissionCheck());
          case '/home':
            return MaterialPageRoute(builder: (context) => Homepage());
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
