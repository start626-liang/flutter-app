import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class WriteView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WriteState();
}

class _WriteState extends State<WriteView> {
  final _formKey = GlobalKey<FormState>();
  final _content = TextEditingController();

  File _imageFile;
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
        _imageFile = response.file;
        _imageFileList.add(_imageFile);
      });
    } else {
      _retrieveDataError = response.exception.code;
    }
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

  void _onImageButtonPressed(ImageSource source) async {
    try {
      _imageFile = await ImagePicker.pickImage(source: source);
      setState(() {
        _imageFileList.add(_imageFile);
      });
    } catch (e) {
      _pickImageError = e;
    }
  }

  List<Widget> _buildList() {
    var list = <Widget>[
//      Text(_imageFileList.length.toString()),
      GestureDetector(
        onTap: () async {
          await showDialog(
            context: context,
            builder: (ctx) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
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
                  ],
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
      ),
    ];

    if (0 != _imageFileList.length) {
      for (File file in _imageFileList) {
        list.insert(
          0,
          Container(
            // red box
            child: Platform.isAndroid
                ? FutureBuilder<void>(
                    future: retrieveLostData(),
                    builder:
                        (BuildContext context, AsyncSnapshot<void> snapshot) {
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
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
//    print('isAndroid${Platform.isAndroid}');
//    print('isIOS${Platform.isIOS}');
//    print('isFuchsia${Platform.isFuchsia}');
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign in"),
      ),
      body: Center(
        child: Form(
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
                Wrap(
                  children: _buildList(),
                ),
              ],
            ),
          ),
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
