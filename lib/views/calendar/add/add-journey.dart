import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:jiffy/jiffy.dart';

import 'repetition-select.dart';
import 'warn-select.dart';

class AddJourneyPage extends StatefulWidget {
  // final DateTime time;

  // AddJourneyPage(this.time);

  @override
  _AddJourneyState createState() {
    return _AddJourneyState();
  }
}

class _AddJourneyState extends State<AddJourneyPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _title = TextEditingController();

  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now();

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

  TextFormField _buildAccountFormField() {
    final double _radiusNum = 40;
    return TextFormField(
      controller: _title,
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
        hintText: "事件标题",
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("add"),
        centerTitle: true,
        leading: Icon(Icons.home),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            padding: EdgeInsets.only(right: 3),
            onPressed: () {
              print(222);
            },
          )
        ],
      ),
      body: Center(
        child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                _buildAccountFormField(),
                _buildStartTime(context),
                _buildEndTime(context),
                _buildRepetition(context),
                _buildLineBetween(),
                _buildWarnPage(context),
              ],
            )),
      ),
    );
  }

  Widget _buildRepetition(BuildContext context) {
    return FlatButton(
        onPressed: () async {
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
        },
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                '重复',
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    _repetition,
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

  Widget _buildEndTime(BuildContext context) {
    return FlatButton(
        onPressed: () {
          DatePicker.showDateTimePicker(context,
              theme: DatePickerTheme(
                  headerColor: Colors.orange,
                  backgroundColor: Colors.blue,
                  itemStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                  doneStyle: TextStyle(color: Colors.white, fontSize: 16),
                  cancelStyle: TextStyle(color: Colors.red, fontSize: 16)),
              showTitleActions: true,
              onChanged: (DateTime date) {}, onConfirm: (DateTime date) {
            if (_startTime.millisecondsSinceEpoch <
                date.millisecondsSinceEpoch) {
              setState(() {
                _endTime = date;
              });
            }
          }, currentTime: _endTime, locale: LocaleType.zh);
        },
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                '结束时间',
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    Jiffy(_endTime).format('yyyy-MM-dd h:mm:ss a'),
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

  Widget _buildStartTime(BuildContext context) {
    return FlatButton(
        onPressed: () {
          DatePicker.showDateTimePicker(context,
              theme: DatePickerTheme(
                  headerColor: Colors.orange,
                  backgroundColor: Colors.blue,
                  itemStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                  doneStyle: TextStyle(color: Colors.white, fontSize: 16),
                  cancelStyle: TextStyle(color: Colors.red, fontSize: 16)),
              showTitleActions: true,
              onChanged: (DateTime date) {}, onConfirm: (DateTime date) {
            if (_endTime.millisecondsSinceEpoch < date.millisecondsSinceEpoch) {
              setState(() {
                _endTime = date;
              });
            }
            setState(() {
              _startTime = date;
            });
          }, currentTime: _startTime, locale: LocaleType.zh);
        },
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                '开始时间',
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    Jiffy(_startTime).format('yyyy-MM-dd h:mm:ss a'),
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

  Widget _buildWarnPage(BuildContext context) {
    return FlatButton(
        onPressed: () async {
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
        },
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                '提醒',
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    _warn,
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

class CustomPicker extends CommonPickerModel {
  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  CustomPicker({DateTime currentTime, LocaleType locale})
      : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    this.setLeftIndex(this.currentTime.hour);
    this.setMiddleIndex(this.currentTime.minute);
    this.setRightIndex(this.currentTime.second);
  }

  @override
  String leftStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String middleStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String rightStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String leftDivider() {
    return "|";
  }

  @override
  String rightDivider() {
    return "|";
  }

  @override
  List<int> layoutProportions() {
    return [1, 2, 1];
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            this.currentLeftIndex(),
            this.currentMiddleIndex(),
            this.currentRightIndex())
        : DateTime(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            this.currentLeftIndex(),
            this.currentMiddleIndex(),
            this.currentRightIndex());
  }
}

typedef OnStateUserGet = Function();
