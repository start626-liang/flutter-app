import 'package:flutter/material.dart';

class MyImages extends StatefulWidget {
  final String img;
  MyImages(this.img);
  @override
  MyImagesState createState() => new MyImagesState(this.img);
}

class MyImagesState extends State<MyImages> {
  double _width = 200.0; //通过修改图片宽度来达到缩放效果
  bool previewNoShow = true;
  final String img;
  MyImagesState(this.img);
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
                previewNoShow = false;
              });
            },
            onScaleUpdate: (ScaleUpdateDetails details) {
              setState(() {
                //缩放倍数在0.8到10倍之间
                _width = 200 * details.scale.clamp(.8, 10.0);
              });
            },
            child: Container(
              child: Image.network(
                img,
                width: 300,
              ),
            ),
          )),
        ),
        Offstage(
          offstage: previewNoShow,
          child: GestureDetector(
            onTap: () {
              print(1111);
              setState(() {
                //缩放倍数在0.8到10倍之间
                previewNoShow = true;
              });
            },
            child: Container(
                color: Colors.black26, height: 900, child: Image.network(img)),
          ),
        ),
      ],
    );
  }
}

//          GestureDetector(
//            onTap: () {
//              print(1111);
//              this.previewNoShow = true;
//            },
//            child: Container(
//                color: Colors.black26,
//                height: 900,
//                child: Image.network(img)),
//          ),
