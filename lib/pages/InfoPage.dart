import 'package:flutter/material.dart';
import 'package:tesi_simone_zanin_140833/Reference.dart';

class InfoPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Reference.appTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.label, size: 170, color: Colors.orange,),//TODO cambiare con l'icona dell'app
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset('assets/images/uniud.png', height: 130, width: 130,),
                            ),
                          ],
                        ),
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Dedica"),
                                content: Text("A chi mi ha dato la forza di andare avanti."),
                              );
                            }
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text("Image Tagger", textScaleFactor: 2,),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20,),
                  Text("Applicazione sviluppata come progetto di tesi da", textScaleFactor: 1.2, textAlign: TextAlign.center,),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text("Simone Zanin", textScaleFactor: 2, textAlign: TextAlign.center),
                  ),
                  Text("Matricola 140833", textScaleFactor: 1.2),
                  Text("presso l'Università degli Studi di Udine.\nLaurea triennale in Informatica.", textScaleFactor: 1.2, textAlign: TextAlign.center),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text("Relatore: Chiar.mo professor Ivan Scagnetto", textScaleFactor: 1.2),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}