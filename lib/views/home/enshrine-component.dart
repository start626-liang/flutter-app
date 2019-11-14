import 'package:flutter/material.dart';

class Enshrine extends StatefulWidget {
  final bool _isEnshrine;

  Enshrine(this._isEnshrine);

  @override
  EnshrineState createState() => EnshrineState(this._isEnshrine);
}

class EnshrineState extends State<Enshrine> {
  bool _isEnshrine;
  EnshrineState(this._isEnshrine);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return IconButton(
      icon: Icon(_isEnshrine ? Icons.star : Icons.star_border),
      onPressed: () {
        setState(() {
          _isEnshrine = !_isEnshrine;
        });
      },
    );
  }
}
