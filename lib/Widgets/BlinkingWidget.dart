import 'package:flutter/cupertino.dart';

class BlinkingWidget extends StatefulWidget {

  final Duration duration;
  final Widget first;
  final Widget second;

  BlinkingWidget(this.duration, this.first, this.second, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BlinkingWidgetState();
  
}

class BlinkingWidgetState extends State<BlinkingWidget> with SingleTickerProviderStateMixin {

  AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          FadeTransition(
            opacity: _controller,
            child: widget.first,
          ),
          widget.second
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(duration: widget.duration, vsync: this);
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}