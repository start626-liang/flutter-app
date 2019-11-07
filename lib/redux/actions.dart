import 'package:flutter_test_626/model/User.dart';
class AddItemAction {
  final User user;

  AddItemAction(this.user);
}

class ToggleItemStateAction {
  final User user;

  ToggleItemStateAction(this.user);
}
