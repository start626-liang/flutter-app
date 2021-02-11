import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

import 'package:flutter/material.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'app.dart';
import 'model/Store.dart';
import 'redux/reducers.dart';
import 'model/User.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification(
      {@required this.id,
      @required this.title,
      @required this.body,
      @required this.payload});
}

final String notLogin = '未登录';
Future<void> main() async {
  // needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();
  // NOTE: if you want to find out if the app was launched via notification then you could use the following call and then do something like
  // change the default route of the app
  // var notificationAppLaunchDetails =
  //     await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  var initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
    didReceiveLocalNotificationSubject.add(ReceivedNotification(
        id: id, title: title, body: body, payload: payload));
  });
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    selectNotificationSubject.add(payload);
  });

  final Store initStore = new Store(new User(name: notLogin));
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
//      child: new App(_store),
      child: new App(),
    );
  }
}
