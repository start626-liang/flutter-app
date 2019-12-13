import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'dart:async';
import 'dart:io';

import './custom-Pagination-builder.dart';

void _previewImage(BuildContext context, List<File> _imageFileList) async {
  await showDialog(
    context: context,
    builder: (ctx) {
      //https://juejin.im/post/5c3f3c29f265da6120621048 说明Swiper
      return Scaffold(
        appBar: AppBar(
            // title: Text("Sign in"),
            // actions: <Widget>[
            //   new IconButton(
            //     // action button
            //     icon: new Icon(Icons.save),
            //     onPressed: () {
            //       _localPath
            //           .then((onValue) => print(onValue))
            //           .catchError((onError) => print(onError));
            //     },
            //   ),
            // ],
            ),
        body: Swiper(
          itemBuilder: (BuildContext context, int index) =>
              Image.file(_imageFileList[index]),
          itemCount: _imageFileList.length,
          index: 0,
          pagination: new CustomPaginationBuilder(),
          onTap: (index) => print('点击了第$index'),
        ),
      );
    },
  );
}

class ImageList extends StatefulWidget {
  @override
  _ImageListState createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  List<File> _imageFileList = [];
  dynamic _pickImageError;
  String _retrieveDataError;

  Text _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await ImagePicker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        File imageFile = response.file;
        _imageFileList.add(imageFile);
      });
    } else {
      _retrieveDataError = response.exception.code;
    }
  }

  void _onImageButtonPressed(ImageSource source) async {
    try {
      File imageFile = await ImagePicker.pickImage(source: source);
      print(imageFile.path);
      setState(() {
        _imageFileList.add(imageFile);
      });
    } catch (e) {
      _pickImageError = e;
    }
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

  Widget _buildAddImageEvent() {
    return GestureDetector(
      onTap: () async {
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
      },
      child: Container(
        // red box
        child: Icon(
          Icons.camera_alt,
          color: Colors.grey[500],
        ),
        decoration: BoxDecoration(
          color: Colors.grey[300],
        ),
        width: 100,
        height: 120,
      ),
    );
  }

  Widget _buildImageWidget(data) {
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (data != null) {
      return Image.file(data);
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        '1111.',
        textAlign: TextAlign.center,
      );
    }
  }

  Widget addImage(File file) {
    return GestureDetector(
      onTap: () {
        _previewImage(context, _imageFileList);
//              Navigator.pushNamed(context, '/login');
//                Navigator.pop(context);
      },
      child: Container(
        child: Platform.isAndroid
            ? FutureBuilder<void>(
                future: retrieveLostData(),
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return const Text(
                        '2222.',
                        textAlign: TextAlign.center,
                      );
                    case ConnectionState.done:
                      return _buildImageWidget(file);
                    default:
                      if (snapshot.hasError) {
                        return Text(
                          'Pick image/video error: ${snapshot.error}}',
                          textAlign: TextAlign.center,
                        );
                      } else {
                        return const Text(
                          '33 ',
                          textAlign: TextAlign.center,
                        );
                      }
                  }
                },
              )
            : _buildImageWidget(file),
        decoration: BoxDecoration(
//                    color: Colors.grey[300],
            ),
        width: 100,
        height: 120,
      ),
    );
  }

  List<Widget> _buildList(BuildContext context) {
    var list = <Widget>[
      _buildAddImageEvent(),
    ];

    if (0 != _imageFileList.length) {
      for (File file in _imageFileList) {
        list.insert(0, addImage(file));
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildList(context),
    );
  }
}
