import 'package:flutter/material.dart';

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
      children: buildList
          .map((event) => Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  title: Text(event.toString()),
                  onTap: () => print('$event tapped!'),
                ),
              ))
          .toList(),
    );
  }
}
