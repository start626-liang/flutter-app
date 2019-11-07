// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:flutter_test_626/model/User.dart';
import 'package:flutter_test_626/App.dart';
import 'package:flutter_test_626/redux/reducers.dart';
import 'package:flutter_test_626/model/Store.dart';

void main() {
  final store =
      new DevToolsStore<Store>(cartItemsReducer, initialState: new Store());
  runApp(MyApp(store));
}

class MyApp extends StatelessWidget {
  final DevToolsStore<Store> store;

  MyApp(this.store);
  @override
  Widget build(BuildContext context) {
    return new StoreProvider<Store>(
      store: store,
      child: new App(store),
    );
  }
}
