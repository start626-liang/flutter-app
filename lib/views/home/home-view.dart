import 'package:flutter/material.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

import '../../views/home/drawer-component.dart';
import '../../views/home/enshrine-component.dart';
import '../../views/home/like-component.dart';
import '../../views/home/trample-component.dart';
import 'images.dart';

Image buildImage(BuildContext context) {
  return Image(
    image: AssetImage('1.jpg'),
  );
}

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() {
    return HomeViewState();
  }
}

class HomeViewState extends State<HomeView> {
  void _onVerticalSwipe(SwipeDirection direction) {
    setState(() {
      if (direction == SwipeDirection.up) {
        print('Swiped up!');
      } else {
        print('Swiped down!');
      }
    });
  }

  void _onHorizontalSwipe(SwipeDirection direction) {
    setState(() {
      if (direction == SwipeDirection.left) {
        print('Swiped left!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: Icon(Icons.menu, color: Colors.white), //自定义图标
            onPressed: () {
              // 打开抽屉菜单
              Scaffold.of(context).openDrawer();
            },
          );
        }),
      ),
      body: SimpleGestureDetector(
        onVerticalSwipe: _onVerticalSwipe,
        onHorizontalSwipe: _onHorizontalSwipe,
        swipeConfig: SimpleSwipeConfig(
          verticalThreshold: 40.0,
          horizontalThreshold: 40.0,
          swipeDetectionBehavior: SwipeDetectionBehavior.continuousDistinct,
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              MyImages(buildImage(context)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Enshrine(false),
                  Like(false),
                  Trample(false),
                ],
              ),
            ],
          ),
        ),
      ),
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.pushNamed(context, '/draft_box/write');
          // 权限列表
          Navigator.pushNamed(context, '/permission_handler');
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
