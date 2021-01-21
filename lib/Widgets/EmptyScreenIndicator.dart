import 'package:flutter/material.dart';

class EmptyScreenIndicator extends StatelessWidget {

  final IconData icon;
  final String message;

  EmptyScreenIndicator({this.icon, this.message, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 100,color: Colors.black45,),
          SizedBox(height: 20,),
          Text(message, textAlign: TextAlign.center,)
        ],
      ),
    );
  }

}