import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../../../db/db.dart' as DB;

import '../general-string.dart';
import '../warn-select.dart';
import '../../../general/toast.dart';
import '../../../general/push.dart' as push;
import '../../../db/calendar/travel-sql.dart' as TravelSql;
import '../../../db/calendar/travel-mode.dart';
import '../edit/edit-travel.dart';

class SeeView extends StatefulWidget {
  final int id;

  SeeView({this.id});

  @override
  State<SeeView> createState() => _SeeViewState();
}

class _SeeViewState extends State<SeeView> {
  List _warnList = [
    {
      'name': warnDefaultt,
      'select': false,
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
  Travel _item;

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

    DB.createDB().then((onValue) async {
      Database db = onValue;
      Travel data = await TravelSql.select(db, widget.id);
      setState(() {
        _item = data;
      });
      DB.close(db);
    });

    push.allNotificationRequests().then((onValue) {
      List<String> selectList = [];
      for (int i = 0; i < 10; i++) {
        if (onValue.indexOf(i + widget.id * 10) != -1) {
          _warnList[i]['select'] = true;
          selectList.add(_warnList[i]['name']);
        }
      }
      _warnShowString(selectList);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double _width = 380;
    return Scaffold(
        appBar: AppBar(
          title: Text('查看'),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(
                Icons.keyboard_arrow_left,
                size: 32,
              ),
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
                  final int _id = widget.id * 10 + i;
                  push.cancelNotifications(_id);
                }

                _warnList.forEach((e) {
                  if (e['select']) {
                    push.setOneTime(
                        _item.id * 10 + e['id'],
                        _item.title,
                        _item.notes,
                        e['time'](DateTime.fromMillisecondsSinceEpoch(
                            _item.startTimeMilliseconds)));
                  }
                });
                Navigator.of(context).pop();
                Toast.toast(context, msg: "编辑保存！ ");
              },
            )
          ],
        ),
        body: ConstrainedBox(
          constraints: BoxConstraints.expand(),
          child: Stack(alignment: Alignment.center, children: <Widget>[
            Positioned(
              top: 20,
              child: Column(
                children: <Widget>[
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(widget.id.toString()),
                        Text(widget.id.toString())
                      ],
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width: 1),
                    ),
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 15),
                    width: _width,
                    height: 160,
                  ),
                  Container(
                    width: _width + 30,
                    child: FlatButton(
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    WarnView(_noWarn, _warnList, (bool value) {
                                      setState(() {
                                        _noWarn = value;
                                      });
                                    }, (int item, bool value) {
                                      setState(() {
                                        _warnList[item]['select'] = value;
                                      });
                                    }, (String warn) {
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
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 16),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    _warn,
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 16),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                  )
                                ],
                              )
                            ])),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: 500,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.edit),
                          Text('编辑'),
                        ],
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    EditTravelPage(_item, _warnList)));
                      },
                    ),
                    FlatButton(
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.delete),
                          Text('删除'),
                        ],
                      ),
                      onPressed: () {
                        showDialog(context);
                      },
                    )
                  ],
                ),
                decoration:
                    BoxDecoration(border: Border(top: BorderSide(width: 0.2))),
              ),
            ),
          ]),
        ));
  }

  void showDialog(context) {
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Dialog(
            backgroundColor: Theme.of(context).dialogBackgroundColor,
            elevation: 24.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(2.0))),
            child: IntrinsicWidth(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 20.0),
                    child: DefaultTextStyle(
                      style: Theme.of(context).textTheme.title,
                      child: Semantics(
                        child: Text("提示"),
                        namesRoute: true,
                        container: true,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding:
                          const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
                      child: DefaultTextStyle(
                        style: Theme.of(context).textTheme.title,
                        child: Text("您确定要删除当前文件吗?"),
                      ),
                    ),
                  ),
                  ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        child: Text("取消"),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        }, //关闭对话框
                      ),
                      FlatButton(
                        child: Text("删除"),
                        onPressed: () {
                          Navigator.of(context).pop(true); //关闭对话框
                          DB.createDB().then((onValue) async {
                            Database db = onValue;
                            TravelSql.delete(db, widget.id);

                            //删除本次提醒
                            for (int i = 0; i < 10; i++) {
                              final int _id = widget.id * 10 + i;
                              push.cancelNotifications(_id);
                            }

                            Navigator.pushReplacementNamed(
                                context, '/calendar');
                            Toast.toast(context, msg: "删除成功!");
                            db.close();
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ));
      },
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 150),
      transitionBuilder: _buildMaterialDialogTransitions,
      useRootNavigator: true,
    );
  }

  Widget _buildMaterialDialogTransitions(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ),
      child: child,
    );
  }
}
