import 'package:flutter/widgets.dart';

class Category {
  int id;
  String name;
  double total;
  double max;
  String firstDate;
  String endDate;
  /*
  double monday;
  double tuesday;
  double wednesday;
  double thursday;
  double friday;
  double saturday;
  double sunday;
  */
  categoryMap() {
    var map = Map<String, dynamic>();

    map['id'] = id;
    map['name'] = name;
    map['total'] = total;
    map['max'] = max;
    map['firstDate'] = firstDate;
    map['endDate'] = endDate;
    /*
    map['monday'] = monday;
    map['monday'] = monday;
    map['monday'] = monday;
    map['monday'] = monday;
    map['monday'] = monday;
    map['monday'] = monday;
    map['monday'] = monday;
    */
    return map;
  }
}

List<Category> categoryList = List<Category>(); //list
List<Category>globalList = List<Category>();
//textfields
final catName = TextEditingController();
final catLimit = TextEditingController();

//edit textfields
final catNameEdit = TextEditingController();
final catLimitEdit = TextEditingController();
var catAddModel = Category();
int addCatId;
bool touch = false;
