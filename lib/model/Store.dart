import 'package:flutter_test_626/model/User.dart';

class Store {
  User _user;

  User get user => _user;

  set user(User value) {
    _user = value;
  }

  Store();
}
