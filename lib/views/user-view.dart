// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:flutter_test_626/model/Store.dart';
import 'package:flutter_test_626/model/User.dart';
import 'package:flutter_test_626/redux/actions.dart';

class UserView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<Store, OnStateUserGet>(converter: (store) {
      return (user) => store.dispatch(SetUser(user));
    }, builder: (BuildContext context, OnStateUserGet callback) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Second Screen"),
        ),
        body: Center(
          child: ListView(children: <Widget>[
            UserName(),
            RaisedButton(
              onPressed: () {
                // Navigate back to the first screen by popping the current route
                // off the stack.
                // 通过从堆栈弹出当前路由（Navigate back to the first screen by popping the current route）
                // 来返回到第一个界面（off the stack）
//            Navigator.pop(context);
                final User user = new User('626');
                callback(user);
              },
              child: Text('sign in'),
            ),
          ]),
        ),
      );
    });
  }
}

typedef OnStateUserGet = Function(User user);

class UserName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<Store, User>(
        converter: (store) => store.state.user,
        builder: (BuildContext context, User user) {
          return Text(user.name);
        });
  }
}
