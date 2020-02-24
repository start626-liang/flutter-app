import 'package:flutter/material.dart';

import 'generalString.dart';

typedef SetWarnCallback = Function(String warn);
typedef SetNoWarn = Function(bool value);
typedef SelectWarnList = Function(int item, bool value);


class WarnView extends StatefulWidget {
  final SetWarnCallback setWarnCallback;
  final SetNoWarn setNoWarnCallback;
  final SelectWarnList selectWarnListCallback;
  final bool noWarn;
  final List initWarnList;
  WarnView(
      {this.noWarn,
      this.setNoWarnCallback,
      this.setWarnCallback,
      this.selectWarnListCallback,
      this.initWarnList});

  @override
  State<StatefulWidget> createState() {
    return WarnViewState();
  }
}

class WarnViewState extends State<WarnView> {
  List _warnList;
  bool _warn;
  @override
  void initState() {
    super.initState();
    setState(() {
      _warn = widget.noWarn;
      _warnList = widget.initWarnList;
    });
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

  Widget _buildNoWarnList(BuildContext context) {
    return ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: _warnList.length,
        itemBuilder: (context, item) {
          return CheckboxListTile(
            title: Text(_warnList[item]['name']),
            value: false,
          );
        });
  }

  Widget _buildSelectWarnList(BuildContext context) {
    return ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: _warnList.length,
        itemBuilder: (context, item) {
          return CheckboxListTile(
            title: Text(_warnList[item]['name']),
            value: _warnList[item]['select'],
            onChanged: (bool value) {
              widget.selectWarnListCallback(item, value);
              setState(() {
                _warnList[item]['select'] = value;
              });
              List _selectWarnList = [];
              _warnList.forEach((e) {
                if (e['select']) {
                  _selectWarnList.add(e);
                }
              });
              _warnShowString(_selectWarnList);
            },
          );
        });
  }

  void _warnShowString(List list) {
    switch (list.length) {
      case 0:
        widget.setWarnCallback('无提醒');
        widget.setNoWarnCallback(true);
        break;
      case 1:
        widget.setWarnCallback(list[0]['name']);
        break;
      case 2:
        widget.setWarnCallback('${list[1]['name']},${list[0]['name']}');
        break;
      default:
        widget.setWarnCallback(
            '${list.last['name']},${list[list.length - 2]['name']},...');
    }
  }

  Widget _isWarn() {
    return SwitchListTile(
      title: const Text('不提醒'),
      value: _warn,
      onChanged: (bool value) {
        setState(() {
          _warn = value;
        });
        if (value) {
          widget.setWarnCallback('无提醒');
          widget.setNoWarnCallback(true);
        } else {
          setState(() {
            _warnList.forEach((e) {
              e['select'] = false;
            });
            _warnList[0]['select'] = true;
          });
          widget.setWarnCallback(warnDefaultt);
          widget.selectWarnListCallback(0, true);
          widget.setNoWarnCallback(false);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('????'),
        ),
        body: ListView(
          children: <Widget>[
            _isWarn(),
            _buildLineBetween(),
            _warn ? _buildNoWarnList(context) : _buildSelectWarnList(context)
          ],
        ));
  }
}
