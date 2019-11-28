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
  File _imageFile;
  dynamic _pickImageError;
  bool isVideo = false;
  VideoPlayerController _controller;
  String _retrieveDataError;

  Future<void> _disposeVideoController() async {
    if (_controller != null) {
      await _controller.dispose();
      _controller = null;
    }
  }

  void _onImageButtonPressed(ImageSource source) async {
    if (_controller != null) {
      await _controller.setVolume(0.0);
    }
    try {
      _imageFile = await ImagePicker.pickImage(source: source);
      setState(() {});
    } catch (e) {
      _pickImageError = e;
    }
  }

  @override
  void deactivate() {
    if (_controller != null) {
      _controller.setVolume(0.0);
      _controller.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    _disposeVideoController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            _onImageButtonPressed(ImageSource.gallery);
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
            _onImageButtonPressed(ImageSource.camera);
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