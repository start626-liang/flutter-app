import 'package:flutter/material.dart';
import 'first-screen.dart';
import 'second-screen.dart';
import 'bottom_navigation_widget.dart';

void main() {
  runApp(MaterialApp(
    title: 'Named Routes Demo',
    // Start the app with the "/" named route. In this case, the app starts
    // on the FirstScreen widget.

    // 使用“/”命名路由来启动应用（Start the app with the "/" named route. In our case, the app will start）
    // 在这里，应用将从 FirstScreen Widget 启动（on the FirstScreen Widget）
//    initialRoute: '/',
    home: BottomNavigationWidget(),
    routes: {
      // When navigating to the "/" route, build the FirstScreen widget.
      // 当我们跳转到“/”时，构建 FirstScreen Widget（When we navigate to the "/" route, build the FirstScreen Widget）
      '/first': (context) => FirstScreen(),

      // When navigating to the "/second" route, build the SecondScreen widget.
      // 当我们跳转到“/second”时，构建 SecondScreen Widget（When we navigate to the "/second" route, build the SecondScreen Widget）
      '/second': (context) => SecondScreen(),
    },
  ));
}
