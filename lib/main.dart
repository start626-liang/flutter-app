// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'App.dart';
import 'model/Store.dart';
import 'redux/reducers.dart';
import 'model/User.dart';

final String notLogin = '未登录';
void main() {
  final Store initStore = new Store(new User(notLogin));
  final DevToolsStore store =
      new DevToolsStore<Store>(storeReducer, initialState: initStore);
  runApp(MyApp(store));
}

class MyApp extends StatelessWidget {
  final DevToolsStore<Store> _store;

  MyApp(this._store);
  @override
  Widget build(BuildContext context) {
    return new StoreProvider<Store>(
      store: _store,
      child: new App(_store),
    );
  }
}
