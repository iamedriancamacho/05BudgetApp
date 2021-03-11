import 'package:budget/services/item_service.dart';
import 'package:flutter/widgets.dart';

class Item {
  int id;
  String name;
  String datetime;
  double amount;
  int catID;
  String week;
  itemMap() {
    var map = Map<String, dynamic>();

    map['id'] = id;
    map['catID'] = catID;
    map['name'] = name;
    map['datetime'] = datetime;
    map['amount'] = amount;
    map['week'] = week;
    return map;
  }
}

List<Item> itemList = List<Item>();
List<Item> utilList = List<Item>();
final itemName = TextEditingController();
final itemAmount = TextEditingController();
final itemNameEdit = TextEditingController();
final itemLimitEdit = TextEditingController();
final itemDateEdit = TextEditingController();
//used global because needed sa category
var item = Item();
var itemService = ItemService();
double monD = 0.0,
    tueD = 0.0,
    wedD = 0.0,
    thuD = 0.0,
    friD = 0.0,
    satD = 0.0,
    sunD = 0.0;
DateTime d = DateTime.now();
//2021-02-11 20:45:22.624682
