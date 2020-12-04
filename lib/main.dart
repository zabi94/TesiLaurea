import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tesi_simone_zanin_140833/PersistentData.dart';
import 'package:tesi_simone_zanin_140833/Reference.dart';
import 'package:tesi_simone_zanin_140833/upload_service/UploadManager.dart';
import 'package:tesi_simone_zanin_140833/pages/FullscreenImagePage.dart';
import 'package:tesi_simone_zanin_140833/pages/Homepage.dart';
import 'package:tesi_simone_zanin_140833/pages/PermissionCheck.dart';
import 'package:tesi_simone_zanin_140833/pages/PictureSummaryPage.dart';
import 'package:tesi_simone_zanin_140833/pages/ServerConfigPage.dart';
import 'package:tesi_simone_zanin_140833/pages/SplashPage.dart';
import 'package:tesi_simone_zanin_140833/pages/TakePicturePage.dart';
import 'package:background_fetch/background_fetch.dart' as bg;

import 'pages/ErrorPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Reference.checkPlatform();
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => DatabaseInterface.instance)
        ],
        child: AppContainer(),
      )
  );

  bg.BackgroundFetch.configure(
      bg.BackgroundFetchConfig(
        minimumFetchInterval: 30,
        enableHeadless: true,
        startOnBoot: true,
        requiredNetworkType: bg.NetworkType.UNMETERED,
        stopOnTerminate: false,
        requiresStorageNotLow: false,
        requiresBatteryNotLow: true,
        requiresCharging: false,
        requiresDeviceIdle: false,
        forceAlarmManager: false
      ),
      (String id) async => UploadManager.uploadPending(id, "${(await SharedPreferences.getInstance()).getString(Reference.prefs_server)}:${(await SharedPreferences.getInstance()).getInt(Reference.prefs_port)}")
  );
  DatabaseInterface.instance.getPendingUploads().then((list) {
    list.forEach((pr) {
      print(pr.getFilePath());
    });
  });
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
            return PageRouteBuilder(
                pageBuilder: (_,__,___) => PictureSummaryPage(settings.arguments),
                opaque: false,
                transitionsBuilder: (context, anim, dur, child) => FadeTransition(
                  child: child,
                  opacity: anim,
                )
            );


          case '/gallery/showPicture/full':
            if (!(settings.arguments is String)) {
              return MaterialPageRoute(builder: (context) => ErrorPage(errorMessage: "/gallery/showPicture/full expects a String"));
            }
            return PageRouteBuilder(
                pageBuilder: (_,__,___) => FullscreenImagePage(settings.arguments),
                opaque: false,
                transitionsBuilder: (context, anim, dur, child) => FadeTransition(
                  child: child,
                  opacity: anim,
                )
            );


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
