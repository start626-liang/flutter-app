import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/subjects.dart';

import 'package:flutter/material.dart';

import '../main.dart';

Future<void> cancelAllNotifications() async {
  await flutterLocalNotificationsPlugin.cancelAll();
}

String _toTwoDigitString(int value) {
  return value.toString().padLeft(2, '0');
}

Future<void> showDailyAtTime() async {
  var time = Time(10, 0, 0);
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'repeatDailyAtTime channel id',
      'repeatDailyAtTime channel name',
      'repeatDailyAtTime description');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.showDailyAtTime(
      0,
      'show daily title',
      'Daily notification shown at approximately ${_toTwoDigitString(time.hour)}:${_toTwoDigitString(time.minute)}:${_toTwoDigitString(time.second)}',
      time,
      platformChannelSpecifics);
}

Future<void> showWeeklyAtDayAndTime() async {
  var time = Time(10, 0, 0);
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'show weekly channel id',
      'show weekly channel name',
      'show weekly description');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
      0,
      'show weekly title',
      'Weekly notification shown on Monday at approximately ${_toTwoDigitString(time.hour)}:${_toTwoDigitString(time.minute)}:${_toTwoDigitString(time.second)}',
      Day.Monday,
      time,
      platformChannelSpecifics);
}

Future<void> setOneTime(
  int _id,
  String _title,
  String _body,
  DateTime _time,
) async {
  // print(_time);
  // print(_id);
  var vibrationPattern = Int64List(4);
  vibrationPattern[0] = 0;
  vibrationPattern[1] = 1000;
  vibrationPattern[2] = 5000;
  vibrationPattern[3] = 2000;

  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      _id.toString(), _id.toString(), _id.toString(),
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
      _id, _title, _body, _time, platformChannelSpecifics);
}

/// Schedules a notification that specifies a different icon, sound and vibration pattern
Future<void> scheduleNotification() async {
  var scheduledNotificationDateTime = DateTime.now().add(Duration(seconds: 5));
  var vibrationPattern = Int64List(4);
  vibrationPattern[0] = 0;
  vibrationPattern[1] = 1000;
  vibrationPattern[2] = 5000;
  vibrationPattern[3] = 2000;

  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your other channel id',
      'your other channel name',
      'your other channel description',
      icon: 'secondary_icon',
      sound: 'slow_spring_board',
      largeIcon: 'sample_large_icon',
      largeIconBitmapSource: BitmapSource.Drawable,
      vibrationPattern: vibrationPattern,
      enableLights: true,
      color: const Color.fromARGB(255, 255, 0, 0),
      ledColor: const Color.fromARGB(255, 255, 0, 0),
      ledOnMs: 1000,
      ledOffMs: 500);

  var iOSPlatformChannelSpecifics =
      IOSNotificationDetails(sound: "slow_spring_board.aiff");

  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.schedule(
      0,
      'scheduled title',
      'scheduled body',
      scheduledNotificationDateTime,
      platformChannelSpecifics);
}

Future<void> checkPendingNotificationRequests(BuildContext context) async {
  var pendingNotificationRequests =
      await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  for (var pendingNotificationRequest in pendingNotificationRequests) {
    // print(
    //     'pending notification: [id: ${pendingNotificationRequest.id}, title: ${pendingNotificationRequest.title}, body: ${pendingNotificationRequest.body}, payload: ${pendingNotificationRequest.payload}]');
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

Future<void> repeatNotification() async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'repeating channel123213 id',
      'repeating channel 123131231name',
      'repeating description2321');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.periodicallyShow(0, 'repeating title',
      'repeating body', RepeatInterval.EveryMinute, platformChannelSpecifics);
}
