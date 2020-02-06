import 'package:flutter/material.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';

import 'bottom_navigation_widget.dart';
import 'common/theme.dart';
import 'model/Store.dart';
import 'views/home/home-view.dart';
import 'views/login/login-view.dart';
import 'views/draft_box/select/main.dart';
import 'views/user/user-view.dart';
import 'views/draft_box/write/write-view.dart';
import 'views/calendar/calendar-page.dart';
import 'views/calendar/add/add-journey.dart';

class App extends StatelessWidget {
  final DevToolsStore<Store> _store;

  App(this._store);

  Widget buildLoginViewPage(BuildContext context) {
    return LoginView();
  }

  Widget buildUserViewPage(BuildContext context) {
    return UserView();
  }

  Widget buildHomeViewPage(BuildContext context) {
    return HomeView();
  }

  Widget buildDraftsBoxWritePage(BuildContext context) {
    return WritePage();
  }

  Widget buildDraftsBoxPage(BuildContext context) {
    return DraftsView();
  }

  Widget buildCalendarPage(BuildContext context) {
    return CalendarPage();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Provider Demo',
      theme: appTheme,
      initialRoute: '/t', // 与底部导航栏互斥
      home: BottomNavigationWidget(),
      routes: {
        '/home': (context) => buildHomeViewPage(context),
        '/user': (context) => buildUserViewPage(context),
        '/login': (context) => buildLoginViewPage(context),
        '/draft_box/write': (context) => buildDraftsBoxWritePage(context),
        '/draft_box/list': (context) => buildDraftsBoxPage(context),
        '/calendar': (context) => buildCalendarPage(context),
        '/t': (context) => AddJourneyPage(),
      },
    );
  }
}
