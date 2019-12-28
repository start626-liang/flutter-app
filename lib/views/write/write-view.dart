import 'dart:async';
import 'dart:io';
// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';

// import '../db/db-data-mode.dart';
// import '../db/db.dart';
import 'image-item.dart';
import 'grid-item.dart';

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

class WritePageState extends State<WritePage> with TickerProviderStateMixin {
  List<File> imageFileList = [];
  dynamic _pickImageError;

  @override
  void initState() {
    super.initState();
    _slideController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    _deleteSheetController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    _deleteSheetAnimation =
        Tween(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0)).animate(
            CurvedAnimation(
                parent: _deleteSheetController, curve: Curves.easeOut));
  }

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
                print(_content.text);
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

  final _content = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _content.dispose();
    _slideController.dispose();
    _deleteSheetController.dispose();
    super.dispose();
  }

  // 拦截返回按键
  Future<bool> onBackPressed() async {
    // if (_readyToDelete) {
    //   cancleDeleteAction();
    //   return false;
    // }
    return true;
  }

  WillPopScope createGrid() {
    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Form(
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
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text('Processing Data')));
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 120, left: 10, right: 10),
            child: GridView.builder(
                gridDelegate: _delegate, //一个控制 GridView 中子项布局的委托。
                itemCount: imageFileList.length + 1, //子控件数量
//              scrollDirection: Axis.vertical, //滚动方向
                reverse: false, //组件反向排序
                // controller: null, //滚动控制（滚动监听）
                // primary: null, //滚动控制（滚动监听）
//           physics      滑动类型设置
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: false, //默认false   内容适配
                itemBuilder: (context, index) {
                  Animation<Offset> slideAnimation;
                  // 需要动画时，添加一个位移动画
                  if (_needToAnimate) {
                    slideAnimation = createTargetItemSlideAnimation(index);
                  }
                  if (index == imageFileList.length) {
                    return add();
                  } else {
                    if (0 < imageFileList.length) {
                      // print(index);
                      // 	遍历数返回Widget
                      return GridItem(
                        index: index,
                        child: _itemBuilder(context, index),
                        onItemSelectedChanged: onItemSelected,
                        singleDeleteStart: triggerSingleDelete,
                        singleDeleteCancle: cancleSingleDelete,
                        slideAnimation: slideAnimation,
                        onItemBuild: itemBuildCallBack,
                      );
                    } else {
                      return add();
                    }
                  }
                }),
          ),
          StatefulBuilder(
            builder: (context, state) {
              _deleteSheetState = state;
              return Offstage(
                offstage: !_singleDelete,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SlideTransition(
                    position: _deleteSheetAnimation,
                    child: DragTarget<int>(onWillAccept: (data) {
                      print('=======onWillAccept');
                      print(data);
                      //当推拽到控件里时触发，经常在这里得到传递过来的值。
                      _canAccept = true;
                      return data != null; // dada不是null的时候,接收该数据。
                    }, onAccept: (data) {
                      // 当可接受的数据放在该拖动目标上时调用
                      print('=======onAccept');
                      doSingleDelete(data);
                    }, onLeave: (data) {
                      // 当将给定数据拖到目标上时，并离开时调用
                      print('=======onLeave');
                      _canAccept = false;
                    }, builder: (context, candidateData, rejectedData) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 64.0,
                        child: Material(
                          color: Colors.black54,
                          child: Center(
                            child: Icon(
                              Icons.delete_forever,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      onWillPop: onBackPressed,
    );
    // return CustomAnimateGrid(
    //   formKey: _formKey,
    //   showDialog: _showDialog,
    //   itemCount: imageFileList.length,
    //   itemBuilder: _itemBuilder,
    //   onActionFinished: (indexes) {
    //     indexes.forEach((index) {
    //       imageFileList.removeAt(index);
    //     });
    //     return imageFileList.length;
    //   },
    // );
  }

  // Item选中状态回调 --- 将其从选中item的list中添加或删除
  void onItemSelected(int index, bool isSelected) {
    if (isSelected) {
      selectedItems.add(index);
    } else {
      selectedItems.remove(index);
    }
  }

  // 首次触发时，计算item所占空间的大小，用于计算位移动画的位置
  void itemBuildCallBack(Size size) {
    if (_itemSize == null) {
      _itemSize = size;
    }
  }

// 长按Item触发底部删除条状态回调
  void triggerSingleDelete() {
    _deleteSheetState(() {
      _singleDelete = true;
      _deleteSheetController.forward();
    });
  }

  // 未移动至底部删除条，取消单独删除状态
  bool cancleSingleDelete() {
    // 未移动到指定位置时，隐藏底部删除栏，并刷新item状态 --- 移动到指定位置时，只修改item的状态，不刷新布局
    if (!_canAccept) {
      _deleteSheetController.reverse().whenComplete(() {
        _deleteSheetState(() {
          _canAccept = false;
          _singleDelete = false;
        });
      });
    }
    return _canAccept;
  }

  Widget add() {
    return GestureDetector(
      onTap: _showDialog,
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

  int onActionFinished(indexes) {
    indexes.forEach((index) {
      imageFileList.removeAt(index);
    });
    return imageFileList.length;
  }

  void doSingleDelete(int index) {
    _deleteSheetController.reverse().whenComplete(() {
      _deleteSheetState(() {
        _canAccept = false;
        _singleDelete = false;
        selectedItems.add(index);
      });
      doDeleteAction();
    });
  }

// 获取将会保留的item的index集合
  void getRemainsItemsList() {
    _oldItemCount = imageFileList.length;
    for (int i = 0; i < _oldItemCount; i++) {
      if (selectedItems.contains(i)) {
        continue;
      }
      remainsItems.add(i);
    }
  }

  // 创建指定item的位移动画
  Animation<Offset> createTargetItemSlideAnimation(int index) {
    int startIndex = remainsItems[index];
    if (startIndex != index) {
      Tween<Offset> tween = Tween(
          begin: getTargetOffset(remainsItems[index], index),
          end: Offset(0.0, 0.0));
      return tween.animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
    }
    return null;
  }

  // 返回动画的位置
  Offset getTargetOffset(int startIndex, int endIndex) {
    SliverGridDelegateWithFixedCrossAxisCount delegate = _delegate;
    int horizionalSeparation = (startIndex % delegate.crossAxisCount) -
        (endIndex % delegate.crossAxisCount);
    int verticalSeparation = (startIndex ~/ delegate.crossAxisCount) -
        (endIndex ~/ delegate.crossAxisCount);

    double dx = (delegate.crossAxisSpacing + _itemSize.width) *
        horizionalSeparation /
        _itemSize.width;
    double dy = (delegate.mainAxisSpacing + _itemSize.height) *
        verticalSeparation /
        _itemSize.width;
    return Offset(dx, dy);
  }

  // 删除Item，执行动画，完成后重绘界面
  void doDeleteAction() {
    if (selectedItems.length == 0) {
      // 未选中ite或选中了所有item --- 删除item，然后刷新布局，无动画效果
      setState(() {
        imageFileList.length =
            onActionFinished(selectedItems.reversed.toList());
        selectedItems.clear();
      });
    } else {
      // 选中部分item --- 计算需要动画的item，刷新item布局，加入动画控件，然后统一执行动画，结束后刷新布局
      getRemainsItemsList();
      setState(() {
        _needToAnimate = true;
        imageFileList.length =
            onActionFinished(selectedItems.reversed.toList());
      });
      _slideController.forward().whenComplete(() {
        setState(() {
          /**
           * 在动画开始执行后开始生成动画帧，屏幕每刷新一次就是一个动画帧，
           * 在动画的每一帧，会随着根据动画的曲线来生成当前的动画值
           */
          _slideController.value = 0.0;
          _needToAnimate = false;
          selectedItems.clear();
          remainsItems.clear();
        });
      });
    }
  }

  final List<int> selectedItems = []; // 被选中的item的index集合
  final List<int> remainsItems = []; // 删除后将会保留的item的index集合

  Size _itemSize;

  StateSetter _deleteSheetState;

  AnimationController _slideController;
  AnimationController _deleteSheetController;
  Animation<Offset> _deleteSheetAnimation;

  int _oldItemCount;

  bool _needToAnimate = false; // 是否需要进行平移动画
  bool _singleDelete = false; // 是否是单独删除状态，长按item触发

  bool _canAccept = false; // 长按删除时，是否移动到了指定位置
  final SliverGridDelegate _delegate =
      SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 4, //列数，即一行有几个子元素；
    crossAxisSpacing: 8.0, //次轴方向上的空隙间距
    mainAxisSpacing: 8.0, //主轴方向上的空隙间距
    childAspectRatio: 1.0, //子元素的宽高比例
  );
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
