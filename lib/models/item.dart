import 'package:budget/services/item_service.dart';
import 'package:flutter/widgets.dart';

class Item {
  int id;
  String name;
  String datetime;
  double amount;
  int catID;

  itemMap() {
    var map = Map<String, dynamic>();

    map['id'] = id;
    map['catID'] = catID;
    map['name'] = name;
    map['datetime'] = datetime;
    map['amount'] = amount;

    return map;
  }
}

List<Item> itemList = List<Item>();

final itemName = TextEditingController();
final itemAmount = TextEditingController();
final itemNameEdit = TextEditingController();
final itemLimitEdit = TextEditingController();

//used global because needed sa category
var item = Item();
var itemService = ItemService();

DateTime d = DateTime.now();
//2021-02-11 20:45:22.624682