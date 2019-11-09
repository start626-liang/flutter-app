// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:flutter_test_626/model/Store.dart';
import 'package:flutter_test_626/model/User.dart';
import 'package:flutter_test_626/main.dart';

class HomeView extends StatelessWidget {
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
      body: Center(
        child: RaisedButton(
          child: Text('Launch screen'),
          onPressed: () {
            // Navigate to the second screen using a named route.
            // 使用命名路由跳转到第二个界面（Navigate to the second screen using a named route）
            Navigator.pushNamed(context, '/login');
          },
        ),
      ),
      drawer: _Drawer(),
    );
  }
}

class _Drawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<Store, User>(
      converter: (store) => store.state.user,
      builder: (BuildContext context, User user) {
        return Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            //边框设置
                            decoration: new BoxDecoration(
                              //背景
                              color: Colors.white,
                              //设置四周圆角 角度
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              //设置四周边框
                              border:
                                  new Border.all(width: 2, color: Colors.white),
                              image: DecorationImage(
                                  image: new NetworkImage(user.name != notLogin
                                      ? 'https://tse3-mm.cn.bing.net/th?id=OIP.dXCIsZadSAJ3uGlYfRljmgHaHa&w=204&h=196&c=7&o=5&pid=1.7'
                                      : '')),
                            ),
                            child: Icon(Icons.account_circle,
                                color: Colors.black12, size: 60),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8.0),
                        child: Text(user.name),
                      ),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: Text(user.name),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer

//              Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

//typedef OnStateChanged = Function(Store item);
