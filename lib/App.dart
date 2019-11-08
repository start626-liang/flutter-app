import 'package:flutter/material.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';

import 'package:flutter_test_626/bottom_navigation_widget.dart';
import 'package:flutter_test_626/model/Store.dart';
import 'package:flutter_test_626/common/theme.dart';
import 'package:flutter_test_626/views/home-view.dart';
import 'package:flutter_test_626/views/user-view.dart';

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
        '/home': (context) => HomeView(),
        '/user': (context) => UserView(),
      },
    );
  }
}
