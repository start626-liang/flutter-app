import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart' as jiffy;

class EventList extends StatelessWidget {
  final List _selectedEvents;
  final List _selectedHolidays;

  EventList(this._selectedEvents, this._selectedHolidays);

  @override
  Widget build(BuildContext context) {
    List buildList = _selectedEvents.toList();
    if (_selectedHolidays.isNotEmpty) {
      buildList.insertAll(0, _selectedHolidays);
    }

    return ListView(
      children: buildList.map((event) {
        print(event);
        return Container(
          decoration: BoxDecoration(
            border: Border.all(width: 0.8),
            borderRadius: BorderRadius.circular(12.0),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ListTile(
            title: Text('${event['title'] == '' ? '（无标题）' : event['title']}'),
            subtitle: Text(
                '${jiffy.Jiffy(event['startTime']).Hm} - ${jiffy.Jiffy(event['endTime']).Hm}${event['site'] == '' ? '' : '  |  ${event['site']}'}'),
            onTap: () => print('$event tapped!'),
          ),
        );
      }).toList(),
    );
  }
}
