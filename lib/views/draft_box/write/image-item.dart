import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:image_picker/image_picker.dart';

import 'custom-Pagination-builder.dart';

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

class ImageItem extends StatefulWidget {
  List<File> _imageFileList;
  int index;
  dynamic _pickImageError;
  ImageItem(this._imageFileList, this.index, this._pickImageError);

  @override
  _ImageItemState createState() => _ImageItemState();
}

class _ImageItemState extends State<ImageItem> {
  String _retrieveDataError;
  Widget _buildImageWidget(data) {
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (data != null) {
      return Image.file(data);
    } else if (widget._pickImageError != null) {
      return Text(
        'Pick image error: ${widget._pickImageError}',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        '1111.',
        textAlign: TextAlign.center,
      );
    }
  }

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
        widget._imageFileList.add(imageFile);
      });
    } else {
      _retrieveDataError = response.exception.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    File indexFile = widget._imageFileList[widget.index];
    return GestureDetector(
      onTap: () {
        print('${widget.index}==============');
        _previewImage(context, widget._imageFileList);
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
                      return _buildImageWidget(indexFile);
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
            : _buildImageWidget(indexFile),
        decoration: BoxDecoration(
//                    color: Colors.grey[300],
            ),
        width: 100,
        height: 120,
      ),
    );
  }
}
