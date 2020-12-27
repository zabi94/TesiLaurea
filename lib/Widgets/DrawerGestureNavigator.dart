import 'package:flutter/material.dart';

class DrawerGestureNavigator extends StatelessWidget {

  final Widget child;

  DrawerGestureNavigator({this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: child,
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity > 0) {
          Scaffold.of(context).openDrawer();
        }
      },
    );
  }

}