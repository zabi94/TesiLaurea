import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {

  final String errorMessage;

  ErrorPage({Key key, @required this.errorMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
              "Error"
          )
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning,
              color: Colors.orange,
              size: 150.0,
            ),
            SizedBox(height: 10,),
            Text(
                errorMessage
            ),
            SizedBox(height: 10,),
            RaisedButton(
              child: Text("Riavvia app"),
              onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil("/", (route) => false),
            )
          ],
        ),
      ),
    );
  }

}