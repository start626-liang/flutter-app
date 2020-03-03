import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../general/toast.dart';

typedef ImageButtonPressed = void Function(ImageSource source);

class AddImageSelect extends StatelessWidget {
  final ImageButtonPressed _onImageButtonPressed;

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
        onTap: () async {
          PermissionStatus permission = await PermissionHandler()
              .checkPermissionStatus(PermissionGroup.storage);

          switch (permission.value) {
            case 4:
              Toast.toast(context, msg: 'photo拒绝访问，并不提示');
              break;
            default:
              _onImageButtonPressed(ImageSource.gallery);
              Navigator.pop(context);
          }
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
        onTap: () async {
          PermissionStatus permission = await PermissionHandler()
              .checkPermissionStatus(PermissionGroup.camera);

          switch (permission.value) {
            case 4:
              Toast.toast(context, msg: 'camera拒绝访问，并不提示');
              break;
            default:
              _onImageButtonPressed(ImageSource.camera);
              Navigator.pop(context);
          }
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
