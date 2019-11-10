// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:community_material_icon/community_material_icon.dart';

import 'package:flutter_test_626/views/home/drawer-component.dart';
import 'package:flutter_test_626/views/home/images.dart';

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
              IconButton(
                icon: Icon(Icons.star_border),
                onPressed: () {},
              ),
              IconButton(
//                icon: Icon(CommunityMaterialIcons.thumb_up),
                icon: Icon(CommunityMaterialIcons.thumb_up_outline),
                onPressed: () {},
              ),
              IconButton(
//                icon: Icon(CommunityMaterialIcons.thumb_down),
                icon: Icon(CommunityMaterialIcons.thumb_down_outline),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
      drawer: MyDrawer(),
    );
  }

  HomeView();
}
