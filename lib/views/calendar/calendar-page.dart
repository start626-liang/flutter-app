import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import './event-list.dart';
import './add/add-journey.dart';

// Example holidays
final Map<DateTime, List> _holidays = {
  DateTime(2020, 1, 1): ['New Year\'s Day'],
  DateTime(2020, 1, 6): ['Epiphany'],
  DateTime(2020, 1, 7): ['Epiphany22222222'],
  DateTime(2020, 1, 27): ['Epiphany11111111'],
  DateTime(2020, 2, 14): ['Valentine\'s Day'],
  DateTime(2020, 4, 21): ['Easter Sunday'],
  DateTime(2020, 4, 22): ['Easter Monday'],
};

class CalendarPage extends StatefulWidget {
  CalendarPage({Key key}) : super(key: key);

  @override
  _CalendarStatePage createState() => _CalendarStatePage();
}

class _CalendarStatePage extends State<CalendarPage>
    with TickerProviderStateMixin {
  Map<DateTime, List> _events;
  DateTime __selectedDay;

  List _selectedEvents;
  List _selectedHolidays;
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    final _selectedDay =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    // 时间 : 行程 Map<DateTime, List> _events
    __selectedDay = _selectedDay;
    _events = {
      _selectedDay.subtract(Duration(days: 4)): [
        'Event A5',
        'Event B5',
        'Event C5'
      ],
      _selectedDay.subtract(Duration(days: 2)): ['Event A6', 'Event B6'],
      _selectedDay: [
        'Event A7222',
        '111Event B7',
        '222Event C7',
        '333Event D7'
      ],
      _selectedDay.add(Duration(days: 1)): [
        '距离1',
        'Event B8',
        'Event C8',
        'Event D8'
      ],
      _selectedDay.add(Duration(days: 3)):
          Set.from(['Event A9', 'Event A9', 'Event B9']).toList(),
      _selectedDay.add(Duration(days: 7)): [
        'Event A10',
        'Event B10',
        'Event C10'
      ],
    };
    
    _selectedEvents = _events[_selectedDay] ?? [];
    _selectedHolidays = _holidays[DateTime(
            _selectedDay.year, _selectedDay.month, _selectedDay.day)] ??
        [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('calendar'),
      ),
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AddJourneyPage(time: __selectedDay, events: _events),
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
