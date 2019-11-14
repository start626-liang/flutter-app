// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'package:flutter_test_626/views/home/drawer-component.dart';
import 'package:flutter_test_626/views/home/images.dart';
import 'package:flutter_test_626/views/home/enshrine-component.dart';
import 'package:flutter_test_626/views/home/like-component.dart';
import 'package:flutter_test_626/views/home/trample-component.dart';

class HomeView extends StatelessWidget {
  final String _img =
      'https://cn.bing.com/th?id=OIP.lZiy3876vC2hTJ5ERvg05wHaEn&pid=Api&rs=1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Screen'),
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
          MyImages(_img),
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
    );
  }

  HomeView();
}
