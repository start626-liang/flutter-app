import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:jiffy/jiffy.dart';
import 'package:time/time.dart';
import 'package:sqflite/sqflite.dart';

import 'repetition-select.dart';
import '../warn-select.dart';
import '../../../general/toast.dart';
import '../../../db/db.dart' as DB;
import '../../../db/calendar/travel-mode.dart';
import '../../../db/calendar/travel-sql.dart' as TravelSql;
import '../../../push/push.dart' as push;
import '../general-string.dart';

class AddTravelPage extends StatefulWidget {
  final DateTime time;
  Map<DateTime, List> events;
  AddTravelPage({this.time, this.events});

  @override
  _AddTravelState createState() {
    return _AddTravelState();
  }
}

class _AddTravelState extends State<AddTravelPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _title = TextEditingController();
  final TextEditingController _site = TextEditingController();
  final TextEditingController _notes = TextEditingController();

  DateTime _startTime;
  DateTime _endTime;

  String _repetition = repetitionDefaultt;
  int _repetitionIndex = 0;

  List _warnList = [
    {
      'name': warnDefaultt,
      'select': true,
      'time': (DateTime time) => time,
      'id': 0
    },
    {
      'name': '提前5分钟',
      'select': false,
      'time': (DateTime time) => time.subtract(Duration(minutes: 5)),
      'id': 1
    },
    {
      'name': '提前10分钟',
      'select': false,
      'time': (DateTime time) => time.subtract(Duration(minutes: 10)),
      'id': 2
    },
    {
      'name': '提前15分钟',
      'select': false,
      'time': (DateTime time) => time.subtract(Duration(minutes: 15)),
      'id': 3
    },
    {
      'name': '提前30分钟',
      'select': false,
      'time': (DateTime time) => time.subtract(Duration(minutes: 30)),
      'id': 4
    },
    {
      'name': '提前1小时',
      'select': false,
      'time': (DateTime time) => time.subtract(Duration(hours: 1)),
      'id': 5
    },
    {
      'name': '提前1天',
      'select': false,
      'time': (DateTime time) => time.subtract(Duration(days: 1)),
      'id': 6
    },
    {
      'name': '提前2天',
      'select': false,
      'time': (DateTime time) => time.subtract(Duration(days: 2)),
      'id': 7
    },
    {
      'name': '提前1周',
      'select': false,
      'time': (DateTime time) => time.subtract(Duration(days: 7)),
      'id': 8
    },
  ];
  String _warn = warnDefaultt;
  bool _noWarn = false;

  TextFormField _buildGeneralFormField(
      TextEditingController value, String hint) {
    final double _radiusNum = 40;
    return TextFormField(
      controller: value,
      decoration: InputDecoration(
        filled: true,
        contentPadding: EdgeInsets.only(left: 20),
        fillColor: Colors.black12,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(_radiusNum),
          ),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(_radiusNum),
            ),
            borderSide: BorderSide(
              color: Colors.green,
              width: 2,
            )),
        hintText: hint,
      ),
    );
  }

  Widget _buildLineBetween() {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Center(
        child: Container(
          width: 320, //max-width is 240
          height: 1,
          color: Colors.grey[300],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final _now = DateTime.now();
    if (widget.time.day == _now.day) {
      _startTime = _now + 1.hours;
      _endTime = _now + 2.hours;
    } else {
      _startTime = DateTime(widget.time.year, widget.time.month,
          widget.time.day, _now.hour, _now.minute);
      _endTime = DateTime(widget.time.year, widget.time.month, widget.time.day,
              _now.hour, _now.minute) +
          1.hours;
    }
  }

  void setTravelEvent(DateTime time, String title, String site,
      DateTime startTime, DateTime endTime) {
    if (widget.events[time] != null) {
      widget.events[time].add({
        'title': title,
        'site': site,
        'startTime': startTime,
        'endTime': endTime
      });
    } else {
      widget.events[time] = [
        {
          'title': title,
          'site': site,
          'startTime': startTime,
          'endTime': endTime
        }
      ];
    }
  }

  void addTravelEvent() {
    final int days_num = _endTime.difference(_startTime).inDays;
    if (0 == days_num) {
      final DateTime _time =
          DateTime(_startTime.year, _startTime.month, _startTime.day);
      setTravelEvent(_time, _title.text, _site.text, _startTime, _endTime);
    } else {
      for (int i = 0; i <= days_num; i++) {
        DateTime _time =
            DateTime(_startTime.year, _startTime.month, _startTime.day + i);
        if (0 == i) {
          setTravelEvent(_time, _title.text, _site.text, _startTime,
              DateTime(0, 0, 0, 24));
        } else if (i == days_num) {
          setTravelEvent(
              _time, _title.text, _site.text, DateTime(0, 0, 0, 0), _endTime);
        } else {
          setTravelEvent(_time, _title.text, _site.text, DateTime(0, 0, 0, 0),
              DateTime(0, 0, 0, 24));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("add"),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            padding: EdgeInsets.only(right: 3),
            onPressed: () async {
              addTravelEvent();

              await DB.createDB().then((onValue) async {
                Database db = onValue;
                final String title = _title.text;
                final String site = _site.text;
                final String notes = _notes.text;
                final Travel fido = Travel(
                    title: title,
                    site: site,
                    notes: notes,
                    startTimeMilliseconds: _startTime.millisecondsSinceEpoch,
                    endTimeMilliseconds: _endTime.millisecondsSinceEpoch,
                    time: Jiffy().format('yyyy-MM-dd h:mm:ss a'));
                final int id = await TravelSql.insert(fido, db);
                Travel _item = await TravelSql.select(db, id);
                _warnList.forEach((e) {
                  if (e['select']) {
                    push.setOneTime(_item.id * 10 + e['id'], title, notes,
                        e['time'](_startTime));
                  }
                });

                Navigator.pop(context);
                Toast.toast(context, msg: "添加成功！ ");
                DB.close(db);
              });
            },
          )
        ],
      ),
      body: Center(
        child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                _buildGeneralFormField(_title, '事件标题'),
                _buildGeneralColumn(context, '开始时间',
                    '${Jiffy(_startTime).yMd} ${Jiffy(_startTime).Hm}', () {
                  DatePicker.showDateTimePicker(context,
                      theme: DatePickerTheme(
                          headerColor: Colors.orange,
                          backgroundColor: Colors.blue,
                          itemStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                          doneStyle:
                              TextStyle(color: Colors.white, fontSize: 16),
                          cancelStyle:
                              TextStyle(color: Colors.red, fontSize: 16)),
                      showTitleActions: true,
                      onChanged: (DateTime date) {},
                      onConfirm: (DateTime date) {
                    if (_endTime.millisecondsSinceEpoch <
                        date.millisecondsSinceEpoch) {
                      setState(() {
                        _endTime = date + 1.hours;
                      });
                    }
                    setState(() {
                      _startTime = date;
                    });
                  }, currentTime: _startTime, locale: LocaleType.zh);
                }),
                _buildGeneralColumn(context, '结束时间',
                    '${Jiffy(_endTime).yMd} ${Jiffy(_endTime).Hm}', () {
                  DatePicker.showDateTimePicker(context,
                      theme: DatePickerTheme(
                          headerColor: Colors.orange,
                          backgroundColor: Colors.blue,
                          itemStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                          doneStyle:
                              TextStyle(color: Colors.white, fontSize: 16),
                          cancelStyle:
                              TextStyle(color: Colors.red, fontSize: 16)),
                      showTitleActions: true,
                      onChanged: (DateTime date) {},
                      onConfirm: (DateTime date) {
                    if (_startTime.millisecondsSinceEpoch <
                        date.millisecondsSinceEpoch) {
                      setState(() {
                        _endTime = date;
                      });
                    }
                  }, currentTime: _endTime, locale: LocaleType.zh);
                }),
                _buildGeneralColumn(context, '重复', _repetition, () async {
//                  Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                        builder: (context) => EepetitionView(
//                            startTime: _startTime,
//                            index: _repetitionIndex,
//                            repetitionCallback: (int index, String repetition) {
//                              setState(() {
//                                _repetitionIndex = index;
//                                _repetition = repetition;
//                              });
//                            })),
//                  );
                }),
                _buildLineBetween(),
                _buildGeneralColumn(context, '提醒', _warn, () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WarnView(
                            noWarn: _noWarn,
                            initWarnList: _warnList,
                            setNoWarnCallback: (bool value) {
                              setState(() {
                                _noWarn = value;
                              });
                            },
                            selectWarnListCallback: (int item, bool value) {
                              setState(() {
                                _warnList[item]['select'] = value;
                              });
                            },
                            setWarnCallback: (String warn) {
                              setState(() {
                                _warn = warn;
                              });
                            })),
                  );
                }),
                _buildLineBetween(),
                _buildGeneralFormField(_site, '地点'),
                _buildGeneralFormField(_notes, '备注'),
              ],
            )),
      ),
    );
  }

  Widget _buildGeneralColumn(
    BuildContext context,
    String title,
    var value,
    Function onPressed,
  ) {
    return FlatButton(
        onPressed: onPressed,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    value,
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  )
                ],
              )
            ]));
  }
}

typedef OnStateUserGet = Function();
