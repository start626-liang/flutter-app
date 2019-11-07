import 'package:flutter_test_626/model/Store.dart';
import 'package:flutter_test_626/model/User.dart';
import 'package:flutter_test_626/redux/actions.dart';


Store cartItemsReducer(
    Store items, dynamic action) {
  if (action is AddItemAction) {
    return addItem(items, action);
  } else if (action is ToggleItemStateAction) {
    return toggleItemState(items, action);
  }
  return items;
}

Store addItem(Store items, AddItemAction action) {
//  return new List.from(items)..add(action.item);
}

Store toggleItemState(
    Store items, ToggleItemStateAction action) {
//  List<User> itemsNew = items
//      .map((item) =>
//          item.name == action.item.name ? action.item : item)
//      .toList();
//  return itemsNew;
}
