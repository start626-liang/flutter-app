import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:jiffy/jiffy.dart';
import 'package:time/time.dart';
import 'package:sqflite/sqflite.dart';

import '../repetition-select.dart';
import '../warn-select.dart';
import '../../../general/toast.dart';
import '../../../db/db.dart' as DB;
import '../../../db/calendar/travel-mode.dart';
import '../../../db/calendar/travel-sql.dart' as TravelSql;
import '../../../push/push.dart' as push;
import '../general-string.dart';

class EditTravelPage extends StatefulWidget {
  List warnList;
  Travel item;
  EditTravelPage(this.item, this.warnList);

  @override
  _EditTravelState createState() {
    return _EditTravelState();
  }
}

class _EditTravelState extends State<EditTravelPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _title = TextEditingController();
  final TextEditingController _site = TextEditingController();
  final TextEditingController _notes = TextEditingController();

  DateTime _startTime;
  DateTime _endTime;

  String _repetition = repetitionDefaultt;
  int _repetitionIndex = 0;

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

  void _warnShowString(List<String> list) {
    setState(() {
      switch (list.length) {
        case 0:
          _warn = '无提醒';
          break;
        case 1:
          _warn = list[0];
          break;
        case 2:
          _warn = '${list[1]},${list[0]}';
          break;
        default:
          _warn = '${list.last},${list[list.length - 2]},...';
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.fromMillisecondsSinceEpoch(
        (widget.item.startTimeMilliseconds));
    _endTime =
        DateTime.fromMillisecondsSinceEpoch(widget.item.endTimeMilliseconds);
    _title.text = widget.item.title;
    _site.text = widget.item.site;
    _notes.text = widget.item.notes;

    List<String> _selectWarnList = [];
    widget.warnList.forEach((e) {
      if (e['select']) {
        _selectWarnList.add(e['name']);
      }
    });
    _warnShowString(_selectWarnList);
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
              //删除本次提醒
              for (int i = 0; i < 10; i++) {
                final int _id = widget.item.id * 10 + i;
                push.cancelNotifications(_id);
              }

              DB.createDB().then((onValue) async {
                Database db = onValue;
                final String title = _title.text;
                final String site = _site.text;
                final String notes = _notes.text;
                final Travel fido = Travel(
                    id: widget.item.id,
                    title: title,
                    site: site,
                    notes: notes,
                    startTimeMilliseconds: _startTime.millisecondsSinceEpoch,
                    endTimeMilliseconds: _endTime.millisecondsSinceEpoch,
                    time: Jiffy().format('yyyy-MM-dd h:mm:ss a'));
                TravelSql.update(fido, db);

                Travel _item = await TravelSql.select(db, widget.item.id);
                widget.warnList.forEach((e) {
                  if (e['select']) {
                    push.setOneTime(_item.id * 10 + e['id'], title, notes,
                        e['time'](_startTime));
                  }
                });

                Navigator.pushReplacementNamed(context, '/calendar');
                Toast.toast(context, msg: "已保存！ ", showTime: 3000);
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            EepetitionView(_startTime, _repetitionIndex,
                                (int index, String repetition) {
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
                        builder: (context) =>
                            WarnView(_noWarn, widget.warnList, (bool value) {
                              setState(() {
                                _noWarn = value;
                              });
                            }, (int item, bool value) {
                              setState(() {
                                widget.warnList[item]['select'] = value;
                              });
                            }, (String warn) {
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
