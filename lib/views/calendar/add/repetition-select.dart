import 'package:flutter/material.dart';

typedef SetRepetitionIndex = Function(int index, String repetition);

class EepetitionView extends StatefulWidget {
  final DateTime startTime;
  final int index;
  final SetRepetitionIndex repetitionCallback;

  EepetitionView({this.startTime, this.index, this.repetitionCallback});

  @override
  State<StatefulWidget> createState() {
    return EepetitionViewState();
  }
}

class EepetitionViewState extends State<EepetitionView> {
  List<String> _repetitionList;
  int _index;
  @override
  void initState() {
    super.initState();
    setState(() {
      _index = widget.index;
      _repetitionList = [
        '一次性活动',
        '每天',
        '周一到周五',
        '每周（每周的星期${widget.startTime.weekday}）',
        '每月（${widget.startTime.day}号）',
        '每年（${widget.startTime.month}月${widget.startTime.day}日）',
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('????'),
        ),
        body: ListView.builder(
            itemCount: _repetitionList.length,
            itemBuilder: (context, item) {
              return FlatButton(
                onPressed: () {
                  widget.repetitionCallback(item, _repetitionList[item]);
                  print(_index);
                  setState(() {
                    _index = item;
                  });
                },
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          left: item == _index ? 8 : 0, right: 8),
                      child: item == _index
                          ? Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                            )
                          : Icon(null),
                    ),
                    Text(
                      _repetitionList[item],
                      style: TextStyle(color: Colors.blue, fontSize: 18),
                    ),
                  ],
                ),
              );
            }));
  }
}
