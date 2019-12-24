import 'dart:async';
import 'dart:io';
// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';

// import '../db/db-data-mode.dart';
// import '../db/db.dart';
import 'custom-animate-grid.dart';
import 'image-item.dart';

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

class WritePage extends StatefulWidget {
  @override
  WritePageState createState() => WritePageState();
}

class WritePageState extends State<WritePage> {
  List<File> imageFileList = [];
  dynamic _pickImageError;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _showDialog() async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _buildAddImageChoiceList(),
          ),
        );
      },
    );
  }

  List<Widget> _buildAddImageChoiceList() {
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

  void _onImageButtonPressed(ImageSource source) async {
    try {
      File imageFile = await ImagePicker.pickImage(source: source);
      print(imageFile.path);
      setState(() {
        imageFileList.add(imageFile);
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blue,
      appBar: AppBar(
        // title: Text("Sign in"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              // Database db1;
              // await db().then((onValue) => db1 = onValue);
              // var fido = Dog(
              //   id: Random().nextInt(10000),
              //   name: 'Fido',
              //   age: Random().nextInt(10000),
              // );
              // await insertDog(fido, db1);
              // print(await dogs(db1));
              // _localPath
              //     .then((onValue) => print(onValue))
              //     .catchError((onError) => print(onError));
              // insertDog(null, database);
              print('==============222===============13');
              if (_formKey.currentState.validate()) {
                // If the form is valid, display a Snackbar.
//                Scaffold.of(context)
//                    .showSnackBar(SnackBar(content: Text('Processing Data')));
                print('222222---------------------------');
              } else {
                print('==================================111');
              }
            },
          ),
        ],
      ),
      body: createGrid(),
    );
  }

  CustomAnimateGrid createGrid() {
    return CustomAnimateGrid(
      formKey: _formKey,
      showDialog: _showDialog,
      itemCount: imageFileList.length,
      itemBuilder: _itemBuilder,
      onActionFinished: (indexes) {
        indexes.forEach((index) {
          imageFileList.removeAt(index);
        });
        return imageFileList.length;
      },
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return Material(
      child: ImageItem(imageFileList, index, _pickImageError),
    );
  }
}

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