import 'package:flutter/material.dart';

class MyImages extends StatefulWidget {
  final String _img;
  MyImages(this._img);
  @override
  MyImagesState createState() => new MyImagesState(this._img);
}

class MyImagesState extends State<MyImages> {
  bool _previewNoShow = true;
  final String _img;
  MyImagesState(this._img);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          child: Center(
              child: GestureDetector(
            onTap: () {
              print(222);
              setState(() {
                //缩放倍数在0.8到10倍之间
                _previewNoShow = false;
              });
            },
            child: Container(
              child: Image.network(
                _img,
                width: 300,
              ),
            ),
          )),
        ),
        Offstage(
          offstage: _previewNoShow,
          child: GestureDetector(
            onTap: () {
              print(1111);
              setState(() {
                //缩放倍数在0.8到10倍之间
                _previewNoShow = true;
              });
            },
            child: Container(
                color: Colors.black26, height: 900, child: Image.network(_img)),
          ),
        ),
      ],
    );
  }
}
