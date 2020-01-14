import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

typedef ImageButtonPressed = void Function(ImageSource source);

class AddImageSelect extends StatelessWidget {
  ImageButtonPressed _onImageButtonPressed;

  AddImageSelect(this._onImageButtonPressed);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _buildAddImageSelect(context),
      ),
    );
  }

  List<Widget> _buildAddImageSelect(BuildContext context) {
    return [
      GestureDetector(
        onTap: () {
          _onImageButtonPressed(ImageSource.gallery);
          Navigator.pop(context);
        },
        child: Container(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: Text(
            'photo',
            textAlign: TextAlign.center,
            style: TextStyle(
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
          Navigator.pop(context);
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
    ];
  }
}
