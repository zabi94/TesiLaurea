import 'package:flutter/material.dart';

class TagWidget extends StatefulWidget {

  final String label;
  final Function _getState;
  final Function _onSelectionChanged;
  final int index;

  TagWidget(this.label, this._getState, this._onSelectionChanged, this.index, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TagWidgetState();

}

class _TagWidgetState extends State<TagWidget> {

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      selected: widget._getState(widget.index),
      onSelected: (newSelectionState) {
        setState(() {
          widget._onSelectionChanged(!widget._getState(widget.index), widget.index);
        });
      },
      label: Text(widget.label),
      avatar: _getAvatar(widget._getState(widget.index)),
    );
  }
  
  Widget _getAvatar(bool state) {
    if (state) {
      return Icon(Icons.check);
    }
    return Icon(Icons.add);
  }

}