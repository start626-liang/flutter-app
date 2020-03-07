import 'package:flutter/material.dart';

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

class HomeView extends StatelessWidget {
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
      body: ListView(
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
