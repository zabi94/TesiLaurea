import 'package:flutter/material.dart';

class TagWidget extends StatefulWidget {

  final String _label;
  final bool _initialState;
  final Function _onSelectionChanged;

  TagWidget(this._label, this._initialState, this._onSelectionChanged, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TagWidgetState(this._initialState);

}

class _TagWidgetState extends State<TagWidget> {

  bool _state;

  _TagWidgetState(this._state);

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      selected: _state,
      onSelected: (newSelectionState) {
        setState(() {
          _state = !_state;
        });
        widget._onSelectionChanged(_state, widget._label);

      },
      label: Text(widget._label),
      avatar: _getAvatar(_state),
    );
  }
  
  Widget _getAvatar(bool state) {
    if (state) {
      return Icon(Icons.check);
    }
    return Icon(Icons.add);
  }

}