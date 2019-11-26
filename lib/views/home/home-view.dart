// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import '../../views/home/drawer-component.dart';
import '../../views/home/images.dart';
import '../../views/home/enshrine-component.dart';
import '../../views/home/like-component.dart';
import '../../views/home/trample-component.dart';


class HomeView extends StatelessWidget {
  final String _img =
      'https://cn.bing.com/th?id=OIP.lZiy3876vC2hTJ5ERvg05wHaEn&pid=Api&rs=1';

  Widget _buildButton(
      String text,
      Function onPressed, {
        Color color = Colors.white,
      }) {
    return FlatButton(
      color: color,
      child: Text(text),
      onPressed: onPressed,
    );
  }

  _showDialog(context) async {
    var result = await showDialog(
      context: context,
      builder: (ctx) {
        return Center(
          child:Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: <Widget>[
                _buildButton("返回1", () => Navigator.of(context).pop(1)),
                _buildButton("返回2", () => Navigator.pop(context, 2)),
              ],
            ),
          ),

        );
      },
    );

    print("result = $result");
  }

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
//          Navigator.pushNamed(context, '/write');
          _showDialog(context);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  HomeView();
}
