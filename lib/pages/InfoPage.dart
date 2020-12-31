import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
                  child: InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundImage: AssetImage(
                              'assets/images/logo.png',
                            ),
                            minRadius: 65,
                            maxRadius: 65,
                            foregroundColor: Colors.transparent,
                            backgroundColor: Colors.orangeAccent,
                          )
                        ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 16),
                  child: FittedBox(
                    child: Text("Image Tagger", textScaleFactor: 100,),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Applicazione sviluppata come progetto di tesi da", textScaleFactor: 1.2, textAlign: TextAlign.center,),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text("Simone Zanin", textScaleFactor: 2, textAlign: TextAlign.center),
                ),
                Text("Matricola 140833", textScaleFactor: 1.2),
                Text("presso l'Università degli Studi di Udine.\nLaurea triennale in Informatica.", textScaleFactor: 1.2, textAlign: TextAlign.center),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text("Relatore: Chiar.mo professor\nIvan Scagnetto", textScaleFactor: 1.2, textAlign: TextAlign.center),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

}