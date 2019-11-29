import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class MyDualog extends StatefulWidget {
  MyDualog({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyDualogState createState() => _MyDualogState();
}

class _MyDualogState extends State<MyDualog> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GestureDetector(
          onTap: () {
//            _onImageButtonPressed(ImageSource.gallery);
          },
          child: Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Text(
              'photo',
              textAlign: TextAlign.center,
              style: new TextStyle(
                color: Colors.black38,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.w400,
                fontSize: 22.0,
              ),
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0))),
            width: 300,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey,
          ),
          width: 300,
          height: 1,
        ),
        GestureDetector(
          onTap: () {
//            _onImageButtonPressed(ImageSource.camera);
          },
          child: Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Text(
              'camera',
              textAlign: TextAlign.center,
              style: new TextStyle(
                color: Colors.black38,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.w400,
                fontSize: 22.0,
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16.0),
                  bottomRight: Radius.circular(16.0)),
              color: Colors.white,
            ),
            width: 300,
          ),
        ),
      ],
    );
  }
}