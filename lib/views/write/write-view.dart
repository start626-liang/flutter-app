import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:async';
import 'dart:io';

import 'image-list.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  await for (FileSystemEntity entity in directory.list()) {
    //文件、目录和链接都继承自FileSystemEntity
    //FileSystemEntity.type静态函数返回值为FileSystemEntityType
    //FileSystemEntityType有三个常量：
    //Directory、FILE、LINK、NOT_FOUND
    //FileSystemEntity.isFile .isLink .isDerectory可用于判断类型
    print(entity.path);
  }
  return directory.path;
}

class WritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text("Sign in"),
        actions: <Widget>[
          new IconButton(
            // action button
            icon: new Icon(Icons.save),
            onPressed: () {
              _localPath
                  .then((onValue) => print(onValue))
                  .catchError((onError) => print(onError));
            },
          ),
        ],
      ),
      body: Center(
        child: _WriteView(),
      ),
    );
  }
}

class _WriteView extends StatefulWidget {
  @override
  _WriteState createState() => _WriteState();
}

class _WriteState extends State<_WriteView> {
  final _formKey = GlobalKey<FormState>();
  final _content = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _content,
              autofocus: true,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "please enter",
                border: InputBorder.none,
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            ImageList(),
          ],
        ),
      ),
    );
  }
}

//提交表单
//Padding(
//padding: const EdgeInsets.symmetric(vertical: 16.0),
//child: RaisedButton(
//onPressed: () {
//// Validate returns true if the form is valid, or false
//// otherwise.
//if (_formKey.currentState.validate()) {
//// If the form is valid, display a Snackbar.
//Scaffold.of(context).showSnackBar(
//SnackBar(content: Text('Processing Data')));
//}
//},
//child: Text('Submit'),
//),
//),

//  右下角按钮
//      floatingActionButton: Column(
//        mainAxisAlignment: MainAxisAlignment.end,
//        children: <Widget>[
//          FloatingActionButton(
//            onPressed: () {
//              _onImageButtonPressed(ImageSource.gallery);
//            },
//            heroTag: 'image0',
//            tooltip: 'Pick Image from gallery',
//            child: const Icon(Icons.photo_library),
//          ),
//          Padding(
//            padding: const EdgeInsets.only(top: 16.0),
//            child: FloatingActionButton(
//              onPressed: () {
//                _onImageButtonPressed(ImageSource.camera);
//              },
//              heroTag: 'image1',
//              tooltip: 'Take a Photo',
//              child: const Icon(Icons.camera_alt),
//            ),
//          ),
//        ],
//      ),
