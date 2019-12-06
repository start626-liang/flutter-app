import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'dart:async';
import 'dart:io';

import './custom-Pagination-builder.dart';

class WriteView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WriteState();
}

class _WriteState extends State<WriteView> {
  final _formKey = GlobalKey<FormState>();
  final _content = TextEditingController();

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

  Widget _swiperItemBuilder(BuildContext context, int index) {
    return Image.file(_imageFileList[index]);
  }

  void _previewImage() async {
    await showDialog(
      context: context,
      builder: (ctx) {
        //https://juejin.im/post/5c3f3c29f265da6120621048 说明Swiper
        return Swiper(
          itemBuilder: _swiperItemBuilder,
          itemCount: _imageFileList.length,
          index: 0,
          pagination: new CustomPaginationBuilder(),
          onTap: (index) => print('点击了第$index'),
        );
      },
    );
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

  List<Widget> _buildList() {
    var list = <Widget>[
//      Text(_imageFileList.length.toString()),
      _buildAddImageEvent(),
    ];

    if (0 != _imageFileList.length) {
      for (File file in _imageFileList) {
        list.insert(
            0,
            GestureDetector(
              onTap: () {
                _previewImage();
//              Navigator.pushNamed(context, '/login');
//                Navigator.pop(context);
              },
              child: Container(
                // red box
                child: Platform.isAndroid
                    ? FutureBuilder<void>(
                        future: retrieveLostData(),
                        builder: (BuildContext context,
                            AsyncSnapshot<void> snapshot) {
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
            ));
      }
    }
    return list;
  }

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

  @override
  Widget build(BuildContext context) {
//    print('isAndroid${Platform.isAndroid}');
//    print('isIOS${Platform.isIOS}');
//    print('isFuchsia${Platform.isFuchsia}');
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
