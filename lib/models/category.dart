import 'package:flutter/widgets.dart';

class Category{
  int id;
  String name;
  double total;
  double max;

  categoryMap() {
    var map = Map<String, dynamic>();

    map['id'] = id;
    map['name'] = name;
    map['total'] = total;
    map['max'] = max;
    return map;
  }
}

List<Category> categoryList = List<Category>(); //list

//textfields
final catName = TextEditingController();
final catLimit = TextEditingController();

//edit textfields
final catNameEdit = TextEditingController();
final catLimitEdit = TextEditingController();
