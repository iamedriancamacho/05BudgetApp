import 'dart:async';

import 'package:budget/models/category.dart';
import 'package:budget/models/item.dart';
import 'package:budget/services/category_service.dart';
import 'package:budget/services/item_service.dart';
import 'package:flutter/material.dart';
import 'package:budget/widgets/radial_painter.dart';
import 'package:budget/helpers/color_helper.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:intl/intl.dart';
import 'package:budget/models/days.dart';
import 'package:budget/services/daysServices.dart';
import 'package:flutter/services.dart';

class CategoryScreen extends StatefulWidget {
  final String name;
  final int catID;
  final double catMax;
  final Function updateCat;
  final String firstDate;
  final String endDate;

  CategoryScreen(
      {this.updateCat,
      @required this.firstDate,
      @required this.endDate,
      @required this.name,
      @required this.catID,
      @required this.catMax});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  var _cat = Category(); //update cat
  var _categoryService = CategoryService(); //update cat
  var _item = Item();
  var _itemService = ItemService();
  var item;
  var _daysService = DaysService();
  bool isEditDate = false;
  DateTime firstDayWeek;
  int itemNumber = 20;
  double tempMoney = 0, amount = 0, globalAm = 0;
  var countMoney = 0;
  double percent;
  DateTime newDatetime;
  String date = "Add Date", day;
  @override
  void initState() {
    super.initState();
    getAllItems();
  }

// accessing values from table Days and appending to list
// calculation of weekyl spending chart
  getAllDays() async {
    var days = await _daysService.readDays();
    listDays.clear();
    getAllItems();
    setState(() {
      var daysModel2 = Days();
      days.forEach((daysWeek) {
        daysModel2.id = daysWeek["id"];
        daysModel2.firstWeek = daysWeek["firstWeek"];
        daysModel2.monday = daysWeek["monday"];
        daysModel2.tuesday = daysWeek["tuesday"];
        daysModel2.wednesday = daysWeek["wednesday"];
        daysModel2.thursday = daysWeek["thursday"];
        daysModel2.friday = daysWeek["friday"];
        daysModel2.saturday = daysWeek["saturday"];
        daysModel2.sunday = daysWeek["sunday"];
        if (widget.firstDate == daysWeek["firstWeek"]) {
          chek = daysModel2.monday;
          listDays.add(daysModel2);
          daysIndex = daysModel2.id;
          print("LISTDAYS ${listDays.length}");
          double total = daysModel2.monday +
              daysModel2.tuesday +
              daysModel2.wednesday +
              daysModel2.thursday +
              daysModel2.friday +
              daysModel2.saturday +
              daysModel2.sunday;
          print("TOTAL $total");
          if (total == 0) {
            mon = 0;
            tue = 0;
            wed = 0;
            thu = 0;
            fri = 0;
            sat = 0;
            sun = 0;
          } else {
            mon = (daysModel2.monday / total) * 100;
            tue = (daysModel2.tuesday / total) * 100;
            wed = (daysModel2.wednesday / total) * 100;
            thu = (daysModel2.thursday / total) * 100;
            fri = (daysModel2.friday / total) * 100;
            sat = (daysModel2.saturday / total) * 100;
            sun = (daysModel2.sunday / total) * 100;
          }
          print("SUNDAY IS $sun");
        }
      });
    });
    //getAllDays();
  }

  getAllItems() async {
    // var daysModel = Days();
    tempMoney = 0;
    countMoney = 0;
    itemList = List<Item>();
    var items = await _itemService.readItem();
    // itemList.clear();
    setState(() {
      items.forEach((item) {
        var itemModel = Item();
        itemModel.id = item['id'];
        itemModel.name = item['name'];
        itemModel.datetime = item['datetime'];
        itemModel.amount = item['amount'];
        itemModel.catID = item['catID'];
        itemModel.week = item['week'];
        //checks if catID is correct
        if (itemModel.catID == widget.catID) {
          itemList.add(itemModel);

          print("ITEM LIST IN GET AL ITEMS ${itemList.length}");
          countMoney++;
        }
        if (widget.firstDate == itemModel.week) {
          if (getDayString(itemModel.datetime) == 'Monday') {
            monD = monD + itemModel.amount;
          } else if (getDayString(itemModel.datetime) == 'Tuesday') {
            tueD = tueD + itemModel.amount;
          } else if (getDayString(itemModel.datetime) == 'Wednesday') {
            wedD = wedD + itemModel.amount;
          } else if (getDayString(itemModel.datetime) == 'Thursday') {
            thuD = thuD + itemModel.amount;
          } else if (getDayString(itemModel.datetime) == 'Friday') {
            friD = friD + itemModel.amount;
          } else if (getDayString(itemModel.datetime) == 'Saturday') {
            satD = satD + itemModel.amount;
          } else if (getDayString(itemModel.datetime) == 'Sunday') {
            sunD = sunD + itemModel.amount;
          }

          print("TOTAL FOR MONDAY INGETALL IS $monD");
        }
      });

      if (itemList.isNotEmpty) {
        for (int i = 0; i < countMoney; i++) {
          tempMoney += itemList[i].amount;
        }
/*
        print("TOTAL FOR MONDAY FOR DAYS $monD");
        print("TOTAL FOR TUESDAY FOR DAYS $tueD");
        print("TOTAL FOR WEDNESDAY FOR DAYS $wedD");
        print("TOTAL FOR THU FOR DAYS $thuD");
        print("TOTAL FOR FRI FOR DAYS $friD");
        print("TOTAL FOR SAT FOR DAYS $satD");
        print("TOTAL FOR SUN FOR DAYS $sunD");
        */
        percent = tempMoney / widget.catMax;
      }
    });
    if (tempMoney > 0) {
      _cat.id = widget.catID;
      _cat.max = widget.catMax;
      _cat.name = widget.name;
      _cat.firstDate = widget.firstDate;
      _cat.endDate = widget.endDate;
      _cat.total = tempMoney;

      var result2 = await _categoryService.updateCategory(_cat);
      print(result2);

      widget.updateCat(tempMoney, _cat.id, _cat.name, _cat.max, _cat.firstDate,
          _cat.endDate);
    }
  }

  String getDayString(String day) {
    StringBuffer sb = new StringBuffer();
    String newDay;
    for (int i = 0; i < day.length; i++) {
      if (day[i] != ",") {
        sb.write(day[i]);
      } else
        break;
    }
    newDay = sb.toString();
    return newDay;
  }

  _getDate() async {
    bool go = false;
    //DateTime date;
    newDatetime = await showRoundedDatePicker(
      context: context,
      initialDate: DateTime.now(),
     // initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(DateTime.now().year),
     //lastDate: DateTime(DateTime.now().year),
      borderRadius: 16,
      theme: ThemeData(
        accentColor: Colors.green,
        dialogBackgroundColor: Colors.green[50],
        disabledColor: Colors.red,
      ),
      imageHeader: AssetImage("assets/images/novigrad.jpg"),
      description: "Enter Date for Item",
// disabling first the allowed dates
      listDateDisabled: [
        dis2.subtract(new Duration(days: 0)),
        dis2.subtract(new Duration(days: 1)),
        dis2.subtract(new Duration(days: 2)),
        dis2.subtract(new Duration(days: 3)),
        dis2.subtract(new Duration(days: 4)),
        dis2.subtract(new Duration(days: 5)),
        dis2.subtract(new Duration(days: 6)),
      ],
      // then if tapped, check if avail, if not then it's allowed
      onTapDay: (DateTime dateTime, bool available) {
        if (available) {
          available = false;
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) {
                return AlertDialog(
                  content: Text("You can't add this date."),
                  actions: <Widget>[
                    FlatButton(
                      color: Colors.red,
                      child: Text("Ok"),
                      onPressed: () {
                        Navigator.pop(context);
                        _getDate();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              });
        } else {
          available = true;
          go = true;
        }
        return available;
      },
      textPositiveButton: "SAVE",
      textNegativeButton: "",
    );

    setState(() {
      if (go) {
        date = DateFormat.yMMMMEEEEd().format(newDatetime);
        if (isEditDate) {
          itemDateEdit.text = date;
        } else {
          print("DEFAULT DATE $newDatetime");
          Navigator.pop(context);
          addItem();
          // getAllDays();
        }
      } else
        date = "Add Date";
    });
  }

// function for adding items
  Widget addItem() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        )),
        context: context,
        builder: (BuildContext context) {
          return Column(
            children: <Widget>[
              SizedBox(height: 40.0),
              Text(
                'Add Item',
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontFamily: 'Josefin',
                    fontSize: 20.0),
              ),
              SizedBox(height: 20.0),
              Container(
                width: 300,
                child: TextField(
                  controller: itemName,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    labelText: "Enter an Item",
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                width: 300,
                child: TextField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  controller: itemAmount,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(
                        r'^\d+\.?\d{0,2}')), // input trapping, allowed inputs are one dot, and 2 digits after the dot
                  ],
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    labelText: "Enter an Amount",
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                width: 300,
                child: ListTile(
                  title: Text('$date'),
                  leading: Icon(Icons.date_range),
                  onTap: () {
                    _getDate();

                    // Navigator.pop(context);
                    // addItem();
                  },
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                child: FlatButton(
                  child: Text(
                    "SUBMIT",
                    style: TextStyle(fontSize: 17.0),
                  ),
                  onPressed: () async {
                    //for checking
                    if (date == "Add Date" ||
                        itemAmount.text.isEmpty ||
                        itemName.text.isEmpty) {
                      popUp(context);
                    } else {
                      if (itemName.text.isEmpty ||
                          itemName.text.length > 12 ||
                          double.parse(itemAmount.text) > widget.catMax ||
                          (double.parse(itemAmount.text) + tempMoney) >
                              widget.catMax ||
                          double.parse(itemAmount.text) <= 0) {
                        popUp(context);
                      } else {
                        _item.name = itemName.text;
                        _item.amount = double.parse(itemAmount.text);
                        _item.datetime = date;
                        _item.catID = widget.catID;
                        _item.week = widget.firstDate;
                        var result = await itemService.saveItem(_item);
                        addDays(date, double.parse(itemAmount.text));
                        if (result > 0) {
                          print('RESULT1 is $result');
                        }
                        itemName.text = '';
                        itemAmount.text = '';
                        Navigator.pop(context);
                        getAllItems();
                        date = "Add Date";
                      }
                    }
                  },
                ),
              ),
            ],
          );
        });
    return Container();
  }

// for adding days in adding items
  addDays(String date, double amount) async {
    var daysModel3 = Days();
    var daysWeek1 = await _daysService.readDays();
    print("CURRENT DAY ${widget.firstDate}");
    daysWeek1.forEach((days) {
      if (widget.firstDate == days['firstWeek']) {
        if (getDayString(date) == "Monday") {
          var temp = days['monday'];
          daysModel3.monday = temp + amount;
          daysModel3.id = days['id'];
          daysModel3.firstWeek = days['firstWeek'];
          daysModel3.tuesday = days['tuesday'];
          daysModel3.wednesday = days['wednesday'];
          daysModel3.thursday = days['thursday'];
          daysModel3.friday = days['friday'];
          daysModel3.saturday = days['saturday'];
          daysModel3.sunday = days['sunday'];
          print("DAYSMODEL MONDAY ${daysModel3.monday}");
        } else if (getDayString(date) == "Tuesday") {
          var temp = days['tuesday'];
          daysModel3.tuesday = temp + amount;
          daysModel3.id = days['id'];
          daysModel3.firstWeek = days['firstWeek'];
          daysModel3.monday = days['monday'];
          daysModel3.wednesday = days['wednesday'];
          daysModel3.thursday = days['thursday'];
          daysModel3.friday = days['friday'];
          daysModel3.saturday = days['saturday'];
          daysModel3.sunday = days['sunday'];
          print("DAYSMODEL tue ${daysModel3.tuesday}");
        } else if (getDayString(date) == "Wednesday") {
          var temp = days['wednesday'];
          daysModel3.wednesday = temp + amount;
          daysModel3.id = days['id'];
          daysModel3.firstWeek = days['firstWeek'];
          daysModel3.monday = days['monday'];
          daysModel3.tuesday = days['tuesday'];
          daysModel3.thursday = days['thursday'];
          daysModel3.friday = days['friday'];
          daysModel3.saturday = days['saturday'];
          daysModel3.sunday = days['sunday'];
          print("DAYSMODEL wed ${daysModel3.wednesday}");
        } else if (getDayString(date) == "Thursday") {
          var temp = days['thursday'];
          daysModel3.thursday = temp + amount;
          daysModel3.id = days['id'];
          daysModel3.firstWeek = days['firstWeek'];
          daysModel3.monday = days['monday'];
          daysModel3.tuesday = days['tuesday'];
          daysModel3.wednesday = days['wednesday'];
          daysModel3.friday = days['friday'];
          daysModel3.saturday = days['saturday'];
          daysModel3.sunday = days['sunday'];
          print("DAYSMODEL thu ${daysModel3.thursday}");
        } else if (getDayString(date) == "Friday") {
          var temp = days['friday'];
          daysModel3.friday = temp + amount;
          daysModel3.id = days['id'];
          daysModel3.firstWeek = days['firstWeek'];
          daysModel3.monday = days['monday'];
          daysModel3.tuesday = days['tuesday'];
          daysModel3.wednesday = days['wednesday'];
          daysModel3.thursday = days['thursday'];
          daysModel3.saturday = days['saturday'];
          daysModel3.sunday = days['sunday'];
          print("DAYSMODEL fri ${daysModel3.friday}");
        } else if (getDayString(date) == "Saturday") {
          var temp = days['saturday'];
          daysModel3.saturday = temp + amount;
          daysModel3.id = days['id'];
          daysModel3.firstWeek = days['firstWeek'];
          daysModel3.monday = days['monday'];
          daysModel3.tuesday = days['tuesday'];
          daysModel3.wednesday = days['wednesday'];
          daysModel3.thursday = days['thursday'];
          daysModel3.friday = days['friday'];
          daysModel3.sunday = days['sunday'];
          print("DAYSMODEL sat ${daysModel3.saturday}");
        } else if (getDayString(date) == "Sunday") {
          var temp = days['sunday'];
          daysModel3.sunday = temp + amount;
          daysModel3.id = days['id'];
          daysModel3.firstWeek = days['firstWeek'];
          daysModel3.monday = days['monday'];
          daysModel3.tuesday = days['tuesday'];
          daysModel3.wednesday = days['wednesday'];
          daysModel3.thursday = days['thursday'];
          daysModel3.saturday = days['saturday'];
          daysModel3.friday = days['friday'];
          print("DAYSMODEL sun ${daysModel3.sunday}");
        }
      }
    });
    var result2 = await _daysService.updateDays(daysModel3);
    print(result2);
    getAllDays();
  }

// for updating weekly spending values in editing items
  editWeek(String date) async {
    var daysModel3 = Days();
    var daysWeek1 = await _daysService.readDays();
    setState(() {
      daysWeek1.forEach((days) {
        if (widget.firstDate == days['firstWeek']) {
          if (getDayString(date) == 'Monday') {
            daysModel3.monday = monD;
            daysModel3.id = days['id'];
            daysModel3.firstWeek = days['firstWeek'];
            daysModel3.tuesday = tueD;
            daysModel3.wednesday = wedD;
            daysModel3.thursday = thuD;
            daysModel3.friday = friD;
            daysModel3.saturday = satD;
            daysModel3.sunday = sunD;
          } else if (getDayString(date) == 'Tuesday') {
            daysModel3.tuesday = tueD;
            daysModel3.id = days['id'];
            daysModel3.firstWeek = days['firstWeek'];
            daysModel3.monday = monD;
            daysModel3.wednesday = wedD;
            daysModel3.thursday = thuD;
            daysModel3.friday = friD;
            daysModel3.saturday = satD;
            daysModel3.sunday = sunD;
          } else if (getDayString(date) == 'Wednesday') {
            daysModel3.wednesday = wedD;
            daysModel3.id = days['id'];
            daysModel3.firstWeek = days['firstWeek'];
            daysModel3.monday = monD;
            daysModel3.tuesday = tueD;
            daysModel3.thursday = thuD;
            daysModel3.friday = friD;
            daysModel3.saturday = satD;
            daysModel3.sunday = sunD;
          } else if (getDayString(date) == 'Thursday') {
            daysModel3.thursday = thuD;
            daysModel3.id = days['id'];
            daysModel3.firstWeek = days['firstWeek'];
            daysModel3.monday = monD;
            daysModel3.tuesday = tueD;
            daysModel3.wednesday = wedD;
            daysModel3.friday = friD;
            daysModel3.saturday = satD;
            daysModel3.sunday = sunD;
          } else if (getDayString(date) == 'Friday') {
            daysModel3.friday = friD;
            daysModel3.id = days['id'];
            daysModel3.firstWeek = days['firstWeek'];
            daysModel3.monday = monD;
            daysModel3.tuesday = tueD;
            daysModel3.wednesday = wedD;
            daysModel3.thursday = thuD;
            daysModel3.saturday = satD;
            daysModel3.sunday = sunD;
          } else if (getDayString(date) == 'Saturday') {
            daysModel3.saturday = satD;
            daysModel3.id = days['id'];
            daysModel3.firstWeek = days['firstWeek'];
            daysModel3.monday = monD;
            daysModel3.tuesday = tueD;
            daysModel3.wednesday = wedD;
            daysModel3.thursday = thuD;
            daysModel3.friday = friD;
            daysModel3.sunday = sunD;
          } else if (getDayString(date) == 'Sunday') {
            daysModel3.sunday = sunD;
            daysModel3.id = days['id'];
            daysModel3.firstWeek = days['firstWeek'];
            daysModel3.monday = monD;
            daysModel3.tuesday = tueD;
            daysModel3.wednesday = wedD;
            daysModel3.thursday = thuD;
            daysModel3.saturday = satD;
            daysModel3.friday = friD;
          }
        }
      });
    });

    var result2 = await _daysService.updateDays(daysModel3);
    getAllDays();
    print(result2);
  }

// for deleting weekly spending values
  deductWeek(String date, double amount) async {
    var daysModel3 = Days();
    var daysWeek1 = await _daysService.readDays();
    setState(() {
      daysWeek1.forEach((days) {
        if (widget.firstDate == days['firstWeek']) {
          if (getDayString(date) == "Monday") {
            print("aight");
            var temp = days['monday'];
            daysModel3.monday = temp - amount;
            daysModel3.id = days['id'];
            daysModel3.firstWeek = days['firstWeek'];
            daysModel3.tuesday = days['tuesday'];
            daysModel3.wednesday = days['wednesday'];
            daysModel3.thursday = days['thursday'];
            daysModel3.friday = days['friday'];
            daysModel3.saturday = days['saturday'];
            daysModel3.sunday = days['sunday'];
            print("DAYSMODEL MONDAY ${daysModel3.monday}");
          } else if (getDayString(date) == "Tuesday") {
            var temp = days['tuesday'];
            daysModel3.tuesday = temp - amount;
            daysModel3.id = days['id'];
            daysModel3.firstWeek = days['firstWeek'];
            daysModel3.monday = days['monday'];
            daysModel3.wednesday = days['wednesday'];
            daysModel3.thursday = days['thursday'];
            daysModel3.friday = days['friday'];
            daysModel3.saturday = days['saturday'];
            daysModel3.sunday = days['sunday'];
            print("DAYSMODEL tue ${daysModel3.tuesday}");
          } else if (getDayString(date) == "Wednesday") {
            var temp = days['wednesday'];
            daysModel3.wednesday = temp - amount;
            daysModel3.id = days['id'];
            daysModel3.firstWeek = days['firstWeek'];
            daysModel3.monday = days['monday'];
            daysModel3.tuesday = days['tuesday'];
            daysModel3.thursday = days['thursday'];
            daysModel3.friday = days['friday'];
            daysModel3.saturday = days['saturday'];
            daysModel3.sunday = days['sunday'];
            print("DAYSMODEL wed ${daysModel3.wednesday}");
          } else if (getDayString(date) == "Thursday") {
            var temp = days['thursday'];
            daysModel3.thursday = temp - amount;
            daysModel3.id = days['id'];
            daysModel3.firstWeek = days['firstWeek'];
            daysModel3.monday = days['monday'];
            daysModel3.tuesday = days['tuesday'];
            daysModel3.wednesday = days['wednesday'];
            daysModel3.friday = days['friday'];
            daysModel3.saturday = days['saturday'];
            daysModel3.sunday = days['sunday'];
            print("DAYSMODEL thu ${daysModel3.thursday}");
          } else if (getDayString(date) == "Friday") {
            var temp = days['friday'];
            daysModel3.friday = temp - amount;
            daysModel3.id = days['id'];
            daysModel3.firstWeek = days['firstWeek'];
            daysModel3.monday = days['monday'];
            daysModel3.tuesday = days['tuesday'];
            daysModel3.wednesday = days['wednesday'];
            daysModel3.thursday = days['thursday'];
            daysModel3.saturday = days['saturday'];
            daysModel3.sunday = days['sunday'];
            print("DAYSMODEL fri ${daysModel3.friday}");
          } else if (getDayString(date) == "Saturday") {
            var temp = days['saturday'];
            daysModel3.saturday = temp - amount;
            daysModel3.id = days['id'];
            daysModel3.firstWeek = days['firstWeek'];
            daysModel3.monday = days['monday'];
            daysModel3.tuesday = days['tuesday'];
            daysModel3.wednesday = days['wednesday'];
            daysModel3.thursday = days['thursday'];
            daysModel3.friday = days['friday'];
            daysModel3.sunday = days['sunday'];
            print("DAYSMODEL sat ${daysModel3.saturday}");
          } else if (getDayString(date) == "Sunday") {
            var temp = days['sunday'];
            daysModel3.sunday = temp - amount;
            daysModel3.id = days['id'];
            daysModel3.firstWeek = days['firstWeek'];
            daysModel3.monday = days['monday'];
            daysModel3.tuesday = days['tuesday'];
            daysModel3.wednesday = days['wednesday'];
            daysModel3.thursday = days['thursday'];
            daysModel3.saturday = days['saturday'];
            daysModel3.friday = days['friday'];
            print("DAYSMODEL sun ${daysModel3.sunday}");
          }
        }
      });
    });
    var result2 = await _daysService.updateDays(daysModel3);
    getAllDays();
    print(result2);
  }

  _editList(BuildContext context, categoryID, categoryName, categoryLimit,
      categoryDate) async {
    item = await _itemService.readItemsByID(categoryID);
    // print('_editCategory ${category[0]['id']}');
    // print('_editCategory ${category[0]['name']}');
    // print('_editCategory ${category[0]['max']}');
    setState(() {
      itemNameEdit.text = item[0]['name'] ?? 'NO Name';
      itemLimitEdit.text = item[0]['amount'].toString() ?? 'No Amount';
      itemDateEdit.text = item[0]['datetime'] ?? 'No Date';
    });
    editItemScreen(context);
  }

// for popup dialog
  popUp(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            content:
                Text("Error. There seems to be a problem with your input."),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                child: Text("Ok"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

//func for updating table in editing items
  updateItem() async {}
// for editing items
  editItemScreen(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                child: Text("Cancel"),
                onPressed: () {
                  isEditDate = false;
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Update"),
                color: Colors.green,
                onPressed: () async {
                  //_item.id is AUTOINCREMENT
                  if (itemNameEdit.text.isEmpty ||
                      itemNameEdit.text.length > 12 ||
                      double.parse(itemLimitEdit.text) > widget.catMax ||
                      (double.parse(itemLimitEdit.text) + tempMoney) >
                          widget.catMax) {
                    popUp(context);
                  } else {
                    _item.id = item[0]['id'];
                    _item.name = itemNameEdit.text;
                    _item.datetime = itemDateEdit.text;
                    _item.amount = double.parse(itemLimitEdit.text);
                    _item.catID = widget.catID;
                    _item.week = widget.firstDate;
                    var result = await _itemService.updateItem(_item);
                    getAllItems();
                    editWeek(itemDateEdit.text.toString());

                    if (result > 0) {
                      print('RESULT is $result');
                      Navigator.pop(context);
                      Navigator.pop(context);
                      //idk ngano duha ka pop HUHUHU
                      monD = 0.0;
                      tueD = 0.0;
                      wedD = 0.0;
                      thuD = 0.0;
                      friD = 0.0;
                      satD = 0.0;
                      sunD = 0.0;
                    }
                    isEditDate = false;
                  }
                },
              ),
            ],
            title: Text("Edit Item"),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: itemNameEdit,
                    decoration: InputDecoration(
                      labelText: "Name",
                    ),
                  ),
                  TextField(
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    controller: itemLimitEdit,
                    enabled: true,
                    decoration: InputDecoration(
                      labelText: "Amount - Limit is ₱${widget.catMax}",
                    ),
                  ),
                  TextFormField(
                    showCursor: true,
                    readOnly: true,
                    onTap: () {
                      isEditDate = true;
                      _getDate();
                    },
                    //initialValue: daysUpdate,
                    controller: itemDateEdit,
                    enabled: true,
                    decoration: InputDecoration(
                      labelText: "Date",
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text("${widget.name}"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              monD = 0.0;
              tueD = 0.0;
              wedD = 0.0;
              thuD = 0.0;
              friD = 0.0;
              satD = 0.0;
              sunD = 0.0;
              setState(() {
                //   editWeek(itemDateEdit.text.toString());
              });
              Navigator.pop(context);
              // getAllItems();
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                addItem();
                //   getAllDays();
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(20.0),
                padding: EdgeInsets.all(20.0),
                height: 250.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xffF1F3F6),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                //radial painter
                child: CustomPaint(
                  foregroundPainter: RadialPainter(
                    bgColor: Colors.grey[400],
                    lineColor: getColor(context, tempMoney <= 0 ? 0 : percent),
                    percent: tempMoney <= 0 ? 0 : percent,
                    width: 15.0,
                  ),
                  child: Center(
                    child: Text(
                      '\₱$tempMoney / \₱${widget.catMax}',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              itemList.length != 0
                  ? Container(
                      height: MediaQuery.of(context).size.height / 2,
                      width: MediaQuery.of(context).size.width / 1.18,
                      child: ListView.builder(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          itemCount: itemList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Dismissible(
                              background: Center(
                                child: Container(
                                  padding: EdgeInsets.only(left: 20.0),
                                  color: Colors.red,
                                  child: Icon(
                                    Icons.delete,
                                    size: 35.0,
                                    color: Theme.of(context).accentColor,
                                  ),
                                  alignment: Alignment.centerLeft,
                                ),
                              ),
                              secondaryBackground: Center(
                                child: Container(
                                  padding: EdgeInsets.only(right: 20.0),
                                  color: Colors.orange,
                                  child: Icon(
                                    Icons.create,
                                    size: 35.0,
                                    color: Theme.of(context).accentColor,
                                  ),
                                  alignment: Alignment.centerRight,
                                ),
                              ),
                              key: UniqueKey(),
                              onDismissed: (direction) async {
                                if (direction.toString() ==
                                    "DismissDirection.endToStart") {
                                  // if swiped to the right
                                  daysUpdate = itemList[index].datetime;
                                  print("UPDATE $daysUpdate");
                                  _editList(
                                      context,
                                      itemList[index].id,
                                      itemList[index].name,
                                      itemList[index].amount,
                                      itemList[index].datetime);

                                  editItemScreen(context);
                                } else {
                                  // if swiped to the left
                                  // delete item

                                  var result = await _itemService
                                      .deleteCategory(itemList[index].id);
                                  deductWeek(itemList[index].datetime,
                                      itemList[index].amount);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Deleted ${itemList[index].name}!")));

                                  if (result > 0) {
                                    print('RESULT is $result');
                                    setState(() {
                                      getAllItems();

                                      widget.updateCat(
                                          tempMoney,
                                          _cat.id,
                                          _cat.name,
                                          _cat.max,
                                          _cat.firstDate,
                                          _cat.endDate);
                                    });
                                  }
                                }
                              },
                              //card
                              child: Center(
                                child: Container(
                                  height: 120.0,
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                  decoration: BoxDecoration(boxShadow: [
                                    BoxShadow(
                                        color: Colors.white, blurRadius: 10.0)
                                  ]),
                                  child: Card(
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    color: Color(0xffF1F3F6),
                                    child: ListTile(
                                      //minVerticalPadding: 20.0,
                                      title: Text(
                                        "${itemList[index].name}",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 25.0),
                                      ),
                                      // leading: Text('${itemList[index].id}'),
                                      subtitle:
                                          Text('${itemList[index].datetime}'),
                                      trailing: Text(
                                          " -₱ ${itemList[index].amount}",
                                          style: TextStyle(color: Colors.red)),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    )
                  : Text("No Items Yet!")
            ],
          ),
        ),
      ),
    );
  }
}
