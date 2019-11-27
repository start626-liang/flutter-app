import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

Widget _buildButton(
  String text,
  Function onPressed, {
  Color color = Colors.white,
}) {
  return FlatButton(
    color: color,
    child: Text(text),
    onPressed: onPressed,
  );
}

class ButtonList extends StatefulWidget {
  ButtonList({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ButtonListState createState() => _ButtonListState();
}

class _ButtonListState extends State<ButtonList> {
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
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FlatButton(
            child: Text('photo'),
            onPressed: (){
              _onImageButtonPressed(ImageSource.gallery);
            },
          ),
//          FlatButton(
//            child: Text('camera'),
//            onPressed: (){
//              _onImageButtonPressed(ImageSource.gallery);
//            },
//          ),
        ],
      ),
    );
  }
}
