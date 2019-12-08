import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../model/Store.dart';
import '../../model/User.dart';

class UserView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new StoreConnector<Store, User>(
      converter: (store) => store.state.user,
      builder: (BuildContext context, User user) {
        return Scaffold(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          body: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text(user.name),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: Text(user.name),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer

//              Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
