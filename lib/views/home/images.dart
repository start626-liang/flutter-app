import 'package:flutter/material.dart';

import 'images-dialog.dart';

class MyImages extends StatefulWidget {
  final Image images;
  MyImages(this.images);
  @override
  MyImagesState createState() => new MyImagesState();
}

class MyImagesState extends State<MyImages> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: GestureDetector(
      onTap: () {
        showImagesDialog(context, widget.images);
      },
      child: Container(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: widget.images,
      ),
    ));
  }
}
