import 'package:flutter/material.dart';

class BottomColumnIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 64.0,
      child: Material(
        color: Colors.black54,
        child: Center(
          child: Icon(
            Icons.delete_forever,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
