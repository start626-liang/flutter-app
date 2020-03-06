import 'package:flutter/material.dart';

class Enshrine extends StatefulWidget {
  final bool enshrineDefault;

  Enshrine(this.enshrineDefault);

  @override
  EnshrineState createState() => EnshrineState();
}

class EnshrineState extends State<Enshrine> {
  bool _isEnshrine;
  
  @override
  void initState() {
    super.initState();
    _isEnshrine = widget.enshrineDefault;
  }

  @override
  Widget build(BuildContext context) {
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
