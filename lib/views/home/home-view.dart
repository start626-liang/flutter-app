// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import '../../views/home/drawer-component.dart';
import '../../views/home/enshrine-component.dart';
import '../../views/home/like-component.dart';
import '../../views/home/trample-component.dart';

class HomeView extends StatelessWidget {
  final String _img =
      'https://cn.bing.com/th?id=OIP.lZiy3876vC2hTJ5ERvg05wHaEn&pid=Api&rs=1';

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
          // MyImages(_img),
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
          print(111);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  HomeView();
}
