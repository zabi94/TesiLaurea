import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tesi_simone_zanin_140833/PersistentData.dart';
import 'package:tesi_simone_zanin_140833/Reference.dart';
import 'package:tesi_simone_zanin_140833/pages/FullscreenImagePage.dart';
import 'package:tesi_simone_zanin_140833/pages/Homepage.dart';
import 'package:tesi_simone_zanin_140833/pages/PermissionCheck.dart';
import 'package:tesi_simone_zanin_140833/pages/PictureSummaryPage.dart';
import 'package:tesi_simone_zanin_140833/pages/ServerConfigPage.dart';
import 'package:tesi_simone_zanin_140833/pages/SplashPage.dart';
import 'package:tesi_simone_zanin_140833/pages/TakePicturePage.dart';

import 'pages/ErrorPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Reference.checkPlatform();
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => DatabaseInterface())
        ],
        child: AppContainer(),
      )
  );
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
          case '/firstConfiguration':
            return MaterialPageRoute(builder: (context) => ServerConfigPage());
          case '/gallery/showPicture':
            if (!(settings.arguments is PictureRecord)) {
              return MaterialPageRoute(builder: (context) => ErrorPage(errorMessage: "/gallery/showPicture expects a PictureRecord"));
            }
            return MaterialPageRoute(builder: (context) => PictureSummaryPage(settings.arguments));
          case '/gallery/showPicture/full':
            if (!(settings.arguments is String)) {
              return MaterialPageRoute(builder: (context) => ErrorPage(errorMessage: "/gallery/showPicture/full expects a String"));
            }
            return MaterialPageRoute(builder: (context) => FullscreenImagePage(settings.arguments));
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
