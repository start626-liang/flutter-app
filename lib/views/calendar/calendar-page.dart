import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:sqflite/sqflite.dart';

import '../../push/push.dart' as push;
import './event-list.dart';
import './add/add-travel.dart';
import '../../db/db.dart' as DB;
import '../../db/calendar/travel-mode.dart';
import '../../db/calendar/travel-sql.dart' as TravelSql;

import '../../main.dart';

class SecondScreen extends StatefulWidget {
  SecondScreen(this.payload);

  final String payload;

  @override
  State<StatefulWidget> createState() => SecondScreenState();
}

class SecondScreenState extends State<SecondScreen> {
  String _payload;
  @override
  void initState() {
    super.initState();
    _payload = widget.payload;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Screen with payload: ${(_payload ?? '')}'),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}

// Example holidays
final Map<DateTime, List> _holidays = {
  DateTime(2020, 2, 14): [
    {'title': 'Valentine\'s Day'}
  ],
};

class CalendarPage extends StatefulWidget {
  CalendarPage({Key key}) : super(key: key);

  @override
  _CalendarStatePage createState() => _CalendarStatePage();
}

class _CalendarStatePage extends State<CalendarPage>
    with TickerProviderStateMixin {
  final MethodChannel platform =
      MethodChannel('crossingthestreams.io/resourceResolver');

  Map<DateTime, List> _events;
  DateTime __selectedDay;

  List _selectedEvents;
  List _selectedHolidays;
  AnimationController _animationController;
  CalendarController _calendarController;

  void setEventsEvent(
      Travel _item, DateTime key, DateTime _start, DateTime _end, int _num) {
    if (_events[key.add(Duration(days: _num))] != null) {
      _events[key.add(Duration(days: _num))].add({
        'id': _item.id,
        'title': _item.title,
        'site': _item.site,
        'startTime': _start,
        'endTime': _end
      });
    } else {
      _events[key.add(Duration(days: _num))] = [
        {
          'id': _item.id,
          'title': _item.title,
          'site': _item.site,
          'startTime': _start,
          'endTime': _end
        }
      ];
    }
  }

  void setEventsShow(int _num, DateTime _start, DateTime start, DateTime _end,
      DateTime end, Travel item) {
    if (0 == _num) {
      setEventsEvent(item, _start, start, end, 0);
    } else {
      for (int i = 0; i <= _num; i++) {
        if (0 == i) {
          setEventsEvent(item, _start, start, _end, i);
        } else if (_num == i) {
          setEventsEvent(item, _start, _start, end, i);
        } else {
          setEventsEvent(item, _start, _start, _end, i);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();

    // 推送
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body)
              : null,
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Ok'),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SecondScreen(receivedNotification.payload),
                  ),
                );
              },
            )
          ],
        ),
      );
    });
    selectNotificationSubject.stream.listen((String payload) async {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SecondScreen(payload)),
      );
    });

    // 日历
    final _selectedDay = DateTime.now();
    __selectedDay = _selectedDay;
    _selectedEvents = [];
    _selectedHolidays = _holidays[DateTime(
            _selectedDay.year, _selectedDay.month, _selectedDay.day)] ??
        [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();

    // 时间 : 行程 Map<DateTime, List> _events
    _events = {};
    DB.createDB().then((onValue) async {
      Database db = onValue;
      List DataList = await TravelSql.selectAll(db);
      DataList.forEach((e) {
        final DateTime _startT =
            DateTime.fromMillisecondsSinceEpoch(e.startTimeMilliseconds);
        final DateTime _endT =
            DateTime.fromMillisecondsSinceEpoch(e.endTimeMilliseconds);

        final int days_num = _endT.difference(_startT).inDays;
        setEventsShow(
            days_num,
            DateTime(_startT.year, _startT.month, _startT.day),
            _startT,
            DateTime(_endT.year, _endT.month, _endT.day),
            _endT,
            e);
      });
      setState(() {
        _selectedEvents = _events[DateTime(
                _selectedDay.year, _selectedDay.month, _selectedDay.day)] ??
            [];
      });
      DB.close(db);
    });
  }

  @override
  void dispose() {
    // 推送
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();

    // 日历
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('calendar'), actions: <Widget>[
        // FlatButton(
        //     child: Text('每分钟重复一次通知'),
        //     onPressed: () async {
        //       await push.repeatNotification();
        //     }),
        FlatButton(
            child: Text('查看待处理的通知'),
            onPressed: () async {
              await push.checkPendingNotificationRequests(context);
            }),
        // FlatButton(
        //     child: Text(
        //       '每天大约上午10:00:00重复通知',
        //     ),
        //     onPressed: () async {
        //       await push.showDailyAtTime();
        //     }),
        // FlatButton(
        //     child: Text(
        //       '每周星期一大约10:00:00重复发送通知',
        //     ),
        //     onPressed: () async {
        //       await push.showWeeklyAtDayAndTime();
        //     }),
        // FlatButton(
        //     child: Text(
        //       'Cancel all notifications--取消所有通知',
        //     ),
        //     onPressed: () async {
        //       await push.cancelAllNotifications();
        //     }),
        // FlatButton(
        //     child: Text('安排在5秒钟内显示通知，自定义声音，红色，大图标，红色LED'),
        //     onPressed: () async {
        //       await push.scheduleNotification();
        //     }),
      ]),
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTravelPage(__selectedDay, _events),
              ));
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _buildTableCalendarWithBuilders(),
          const SizedBox(height: 8.0),
          Expanded(
              child: EventList(_selectedEvents, _selectedHolidays)), // 事务列表
        ],
      ),
    );
  }

  void _onDaySelected(DateTime day, List events) {
    print('$day== _onDaySelected??===$__selectedDay');
    final List holidaysList = _holidays[DateTime(day.year, day.month, day.day)];

    setState(() {
      _selectedEvents = events;
      __selectedDay = day;
      if (holidaysList == null) {
        _selectedHolidays = [];
      } else {
        _selectedHolidays = holidaysList;
      }
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged??2222');
  }

  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      // locale: 'pl_PL', // 语种
      calendarController: _calendarController,
      events: _events, // 行程表
      holidays: _holidays, // 节假日
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.monday, // 一周的起始时间
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },
      calendarStyle: CalendarStyle(
        // 日历日期样式
        outsideDaysVisible: false, // 是否补全日历
        weekendStyle: TextStyle().copyWith(color: Colors.red), // 行程日样式
        holidayStyle: TextStyle().copyWith(color: Colors.blue[800]), // 节假日样式
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.blue[600]), // 周末样式
      ),
      headerStyle: HeaderStyle(
        // 头部样式
        centerHeaderTitle: true, // 头部标题是否居中
        formatButtonVisible: false, // 格式化按钮是否显示
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          // 选中样式
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              color: Colors.blue[400],
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          // 今日的样式
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            color: Colors.grey[400],
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          if (holidays.isNotEmpty) {
            children.add(
              Positioned(
                right: -2,
                top: -2,
                child: _buildHolidaysMarker(),
              ),
            );
          }

          return children;
        },
      ),
      onDaySelected: (date, events) {
        // 点击事件
        _onDaySelected(date, events);
        _animationController.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged, //日历翻页事件
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date)
                ? Colors.brown[300]
                : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }
}
