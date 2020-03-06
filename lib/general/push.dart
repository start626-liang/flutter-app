import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

import '../main.dart';

Future<void> cancelNotifications(int id) async {
  await flutterLocalNotificationsPlugin.cancel(id);
}

Future<void> setOneTime(
  int _id,
  String _title,
  String _body,
  DateTime _time,
) async {
  var vibrationPattern = Int64List(4);
  vibrationPattern[0] = 0;
  vibrationPattern[1] = 1000;
  vibrationPattern[2] = 5000;
  vibrationPattern[3] = 2000;

  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      _id.toString(), _id.toString(), _id.toString(),
      importance: Importance.Max,
      priority: Priority.Max,
      icon: 'secondary_icon',
      sound: 'slow_spring_board',
      largeIcon: 'sample_large_icon',
      largeIconBitmapSource: BitmapSource.Drawable,
      enableVibration: true,
      vibrationPattern: vibrationPattern,
      enableLights: true,
      color: const Color.fromARGB(255, 255, 0, 0),
      ledColor: const Color.fromARGB(255, 255, 0, 0),
      ledOnMs: 3000,
      ledOffMs: 1500);

  var iOSPlatformChannelSpecifics =
      IOSNotificationDetails(sound: "slow_spring_board.aiff");

  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.schedule(
      0, _title, _body, _time, platformChannelSpecifics);
}

Future<List<int>> allNotificationRequests() async {
  var pendingNotificationRequests =
      await flutterLocalNotificationsPlugin.pendingNotificationRequests();

  List<int> _list = [];
  for (var pendingNotificationRequest in pendingNotificationRequests) {
    _list.add(pendingNotificationRequest.id);
  }
  return _list;
}

Future<void> checkPendingNotificationRequests(BuildContext context) async {
  var pendingNotificationRequests =
      await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  for (var pendingNotificationRequest in pendingNotificationRequests) {
    debugPrint(
        'pending notification: [id: ${pendingNotificationRequest.id}, title: ${pendingNotificationRequest.title}, body: ${pendingNotificationRequest.body}, payload: ${pendingNotificationRequest.payload}]');
  }
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text(
            '${pendingNotificationRequests.length} pending notification requests'),
        actions: [
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
