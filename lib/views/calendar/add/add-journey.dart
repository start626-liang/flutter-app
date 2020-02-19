import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:jiffy/jiffy.dart';
import 'package:time/time.dart';

import 'repetition-select.dart';
import 'warn-select.dart';
import 'toast.dart';

class AddJourneyPage extends StatefulWidget {
  final DateTime time;
  Map<DateTime, List> events;
  AddJourneyPage({this.time, this.events});

  @override
  _AddJourneyState createState() {
    return _AddJourneyState();
  }
}

class _AddJourneyState extends State<AddJourneyPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _title = TextEditingController();
  final TextEditingController _site = TextEditingController();
  final TextEditingController _notes = TextEditingController();

  DateTime _startTime;
  DateTime _endTime;

  String _repetition = repetitionDefaultt;
  int _repetitionIndex = 0;

  List _warnList = [
    {'name': warnDefaultt, 'select': true},
    {'name': '提前5分钟', 'select': false},
    {'name': '提前10分钟', 'select': false},
    {'name': '提前15分钟', 'select': false},
    {'name': '提前30分钟', 'select': false},
    {'name': '提前1小时', 'select': false},
    {'name': '提前1天', 'select': false},
    {'name': '提前2天', 'select': false},
    {'name': '提前1周', 'select': false},
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
    _startTime = widget.time;
    _endTime = widget.time + 1.hours;
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
            onPressed: () {
              DateTime _time =
                  DateTime(_startTime.year, _startTime.month, _startTime.day);
              if (widget.events[_time] != null) {
                widget.events[_time].add({
                  'title': _title.text,
                  'site': _site.text,
                  'startTime': _startTime,
                  'endTime': _endTime
                });
              } else {
                widget.events[_time] = [
                  {
                    'title': _title.text,
                    'site': _site.text,
                    'startTime': _startTime,
                    'endTime': _endTime
                  }
                ];
              }
              Navigator.pop(context);
              Toast.toast(context, msg: "添加成功！ ");
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EepetitionView(
                            startTime: _startTime,
                            index: _repetitionIndex,
                            repetitionCallback: (int index, String repetition) {
                              setState(() {
                                _repetitionIndex = index;
                                _repetition = repetition;
                              });
                            })),
                  );
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
