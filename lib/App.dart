import 'package:flutter/material.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';
import 'package:flutter_redux_dev_tools/flutter_redux_dev_tools.dart';

import 'package:flutter_test_626/bottom_navigation_widget.dart';
import 'package:flutter_test_626/model/Store.dart';
import 'package:flutter_test_626/common/theme.dart';
import 'package:flutter_test_626/screens/cart.dart';
import 'package:flutter_test_626/screens/catalog.dart';
class App extends StatelessWidget {
  final DevToolsStore<Store> store;

  App(this.store);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Provider Demo',
        theme: appTheme,
//        initialRoute: '/',
        home: BottomNavigationWidget(),
        routes: {
          '/a': (context) => MyCatalog(),
          '/second': (context) => MyCart(),
        },
      );
  }
}
