import 'package:flutter/material.dart';

class AvoidKeyboardWidget extends StatelessWidget {

  final Widget child;

  AvoidKeyboardWidget({this.child, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height - kToolbarHeight - MediaQuery.of(context).padding.top,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(child: child),
    );
  }

}