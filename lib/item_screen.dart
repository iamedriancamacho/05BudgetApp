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

  getAllDays() async {
    var days = await _daysService.readDays();
    var daysModel2 = Days();
    setState(() {
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
      });
      if (widget.firstDate == daysModel2.firstWeek) {
        chek = daysModel2.monday;
        setState(() {
          listDays.clear();
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
          /*
            mon.clear();
            tue.clear();
            wed.clear();
            thu.clear();
            fri.clear();
            sat.clear();
            sun.clear();
            mon.add(daysModel2.monday);
            tue.add(daysModel2.tuesday);
            wed.add(daysModel2.wednesday);
            thu.add(daysModel2.thursday);
            fri.add(daysModel2.friday);
            sat.add(daysModel2.saturday);
            sun.add(daysModel2.sunday);
            */
        });
      }
    });
  }

  getAllItems() async {
    // var daysModel = Days();
    double total = 0;
    tempMoney = 0;
    countMoney = 0;
    itemList = List<Item>();
    var items = await _itemService.readItem();

    setState(() {
      items.forEach((category) {
        var itemModel = Item();
        itemModel.id = category['id'];
        itemModel.name = category['name'];
        itemModel.datetime = category['datetime'];
        itemModel.amount = category['amount'];
        itemModel.catID = category['catID'];
        //checks if catID is correct
        if (itemModel.catID == widget.catID) {
          itemList.add(itemModel);

          countMoney++;
        }
      });

      if (itemList.isNotEmpty) {
        for (int i = 0; i < countMoney; i++) {
          tempMoney += itemList[i].amount;

          //

        }

        print("TOTAL FOR MONDAY $total");
        percent = tempMoney / widget.catMax;
      }
    });

    //var result = await _daysService.updateDaysValue(daysModel, widget.firstDate);
    // print(result);
    //print("TOTAL FOR MONDAY $globalAm");
    if (tempMoney > 0) {
      _cat.id = widget.catID;
      _cat.max = widget.catMax;
      _cat.name = widget.name;
      _cat.firstDate = widget.firstDate;
      _cat.endDate = widget.endDate;
      _cat.total = tempMoney;
      _cat.firstDate = widget.firstDate;
      _cat.endDate = widget.endDate;

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
    //DateTime date;
    newDatetime = await showRoundedDatePicker(
      context: context,
      initialDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
      // firstDate: DateTime(DateTime.now().year - 1),
      // lastDate: DateTime(DateTime.now().year + 1),
      borderRadius: 16,
      theme: ThemeData(primaryColor: Colors.green),
      listDateDisabled: [
        firstDayWeek = new DateTime.now()
            .subtract(new Duration(days: DateTime.now().weekday - 1)),
      ],
    );
    setState(() {
      date = DateFormat.yMMMMEEEEd().format(newDatetime);
      day = DateFormat.EEEE().format(newDatetime).toString();
      Navigator.pop(context);
      addItem();
      getAllDays();
    });
  }

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

                    //end of checking

                    //_item.id is AUTOINCREMENT
                    if (double.parse(itemAmount.text) > widget.catMax ||
                        (double.parse(itemAmount.text) + tempMoney) >
                            widget.catMax ||
                        double.parse(itemAmount.text) <= 0) {
                      popUp(context);
                    } else {
                      _item.name = itemName.text;
                      _item.amount = double.parse(itemAmount.text);
                      _item.datetime = date;
                      _item.catID = widget.catID;
                      var daysModel3 = Days();
                      var result = await itemService.saveItem(_item);
                      var daysWeek1 = await _daysService.readDays();
                      print("CURRENT DAY ${widget.firstDate}");
                      daysWeek1.forEach((days) {
                        if (widget.firstDate == days['firstWeek']) {
                          if (getDayString(_item.datetime) == "Monday") {
                            var temp = days['monday'];
                            daysModel3.monday =
                                temp + double.parse(itemAmount.text);
                            daysModel3.id = days['id'];
                            daysModel3.firstWeek = days['firstWeek'];
                            daysModel3.tuesday = days['tuesday'];
                            daysModel3.wednesday = days['wednesday'];
                            daysModel3.thursday = days['thursday'];
                            daysModel3.friday = days['friday'];
                            daysModel3.saturday = days['saturday'];
                            daysModel3.sunday = days['sunday'];
                            print("DAYSMODEL MONDAY ${daysModel3.monday}");
                          } else if (getDayString(_item.datetime) ==
                              "Tuesday") {
                            var temp = days['tuesday'];
                            daysModel3.tuesday =
                                temp + double.parse(itemAmount.text);
                            daysModel3.id = days['id'];
                            daysModel3.firstWeek = days['firstWeek'];
                            daysModel3.monday = days['monday'];
                            daysModel3.wednesday = days['wednesday'];
                            daysModel3.thursday = days['thursday'];
                            daysModel3.friday = days['friday'];
                            daysModel3.saturday = days['saturday'];
                            daysModel3.sunday = days['sunday'];
                            print("DAYSMODEL tue ${daysModel3.tuesday}");
                          } else if (getDayString(_item.datetime) ==
                              "Wednesday") {
                            var temp = days['wednesday'];
                            daysModel3.wednesday =
                                temp + double.parse(itemAmount.text);
                            daysModel3.id = days['id'];
                            daysModel3.firstWeek = days['firstWeek'];
                            daysModel3.monday = days['monday'];
                            daysModel3.tuesday = days['tuesday'];
                            daysModel3.thursday = days['thursday'];
                            daysModel3.friday = days['friday'];
                            daysModel3.saturday = days['saturday'];
                            daysModel3.sunday = days['sunday'];
                            print("DAYSMODEL wed ${daysModel3.wednesday}");
                          } else if (getDayString(_item.datetime) ==
                              "Thursday") {
                            var temp = days['thursday'];
                            daysModel3.thursday =
                                temp + double.parse(itemAmount.text);
                            daysModel3.id = days['id'];
                            daysModel3.firstWeek = days['firstWeek'];
                            daysModel3.monday = days['monday'];
                            daysModel3.tuesday = days['tuesday'];
                            daysModel3.wednesday = days['wednesday'];
                            daysModel3.friday = days['friday'];
                            daysModel3.saturday = days['saturday'];
                            daysModel3.sunday = days['sunday'];
                            print("DAYSMODEL thu ${daysModel3.thursday}");
                          } else if (getDayString(_item.datetime) == "Friday") {
                            var temp = days['friday'];
                            daysModel3.friday =
                                temp + double.parse(itemAmount.text);
                            daysModel3.id = days['id'];
                            daysModel3.firstWeek = days['firstWeek'];
                            daysModel3.monday = days['monday'];
                            daysModel3.tuesday = days['tuesday'];
                            daysModel3.wednesday = days['wednesday'];
                            daysModel3.thursday = days['thursday'];
                            daysModel3.saturday = days['saturday'];
                            daysModel3.sunday = days['sunday'];
                            print("DAYSMODEL fri ${daysModel3.friday}");
                          } else if (getDayString(_item.datetime) ==
                              "Saturday") {
                            var temp = days['saturday'];
                            daysModel3.saturday =
                                temp + double.parse(itemAmount.text);
                            daysModel3.id = days['id'];
                            daysModel3.firstWeek = days['firstWeek'];
                            daysModel3.monday = days['monday'];
                            daysModel3.tuesday = days['tuesday'];
                            daysModel3.wednesday = days['wednesday'];
                            daysModel3.thursday = days['thursday'];
                            daysModel3.friday = days['friday'];
                            daysModel3.sunday = days['sunday'];
                            print("DAYSMODEL sat ${daysModel3.saturday}");
                          } else if (getDayString(_item.datetime) == "Sunday") {
                            var temp = days['sunday'];
                            daysModel3.sunday =
                                temp + double.parse(itemAmount.text);
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

                      getAllDays();

                      print(result2);
                      if (result > 0) {
                        print('RESULT1 is $result');
                        // Navigator.pop(context);
                        //Navigator.pop(context); //idk ngano duha ka pop HUHUHU
                        //list.clear();
                        //getAllCategories();
                        //widget.updateCat(tempMoney);
                      }

                      // add days in week

                      // end adding of days

                      itemName.text = '';
                      itemAmount.text = '';
                      Navigator.pop(context);
                      getAllItems();

                      date = "Add Date";
                    }
                  },
                ),
              ),
            ],
          );
        });
    return Container();
  }

  editWeek(String date, double amount) async {
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

  _editList(
      BuildContext context, categoryID, categoryName, categoryLimit) async {
    item = await _itemService.readItemsByID(categoryID);
    // print('_editCategory ${category[0]['id']}');
    // print('_editCategory ${category[0]['name']}');
    // print('_editCategory ${category[0]['max']}');
    setState(() {
      itemNameEdit.text = item[0]['name'] ?? 'NO Name';
      itemLimitEdit.text = item[0]['amount'].toString() ?? 'No Amount';
    });
    _editL(context);
  }

  popUp(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            content: Text(
                "Error. There seems to be a problem with your input. You can't add this item."),
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

  _editL(BuildContext context) {
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
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Update"),
                color: Colors.green,
                onPressed: () async {
                  //_item.id is AUTOINCREMENT
                  if (double.parse(itemLimitEdit.text) > widget.catMax ||
                      (double.parse(itemLimitEdit.text) + tempMoney) >
                          widget.catMax) {
                    popUp(context);
                  } else {
                    _item.id = item[0]['id'];
                    _item.name = itemNameEdit.text;
                    _item.datetime = " insert datetime here";
                    _item.amount = double.parse(itemLimitEdit.text);
                    _item.catID = widget.catID;

                    var result = await _itemService.updateItem(_item);
                    if (result > 0) {
                      print('RESULT is $result');
                      Navigator.pop(context);
                      Navigator.pop(context); //idk ngano duha ka pop HUHUHU
                      getAllItems();
                    }
                  }
                },
              ),
            ],
            title: Text("Edit Category"),
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
                    controller: itemLimitEdit,
                    enabled: true,
                    decoration: InputDecoration(
                      labelText: "Limit",
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
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text("${widget.name}"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                addItem();
                getAllDays();
              },
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Center(
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
                      lineColor:
                          getColor(context, tempMoney <= 0 ? 0 : percent),
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
                    ? Expanded(
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
                                    _editList(
                                        context,
                                        itemList[index].id,
                                        itemList[index].name,
                                        itemList[index].amount);

                                    _editL(context);
                                    /*
                                    editWeek(itemList[index].datetime,
                                        itemList[index].amount);
                                        */
                                  } else {
                                    // delete item

                                    var result = await _itemService
                                        .deleteCategory(itemList[index].id);
                                    deductWeek(itemList[index].datetime,
                                        itemList[index].amount);
                                    getAllDays();
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
                                        borderRadius:
                                            BorderRadius.circular(20.0),
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
                                            style:
                                                TextStyle(color: Colors.red)),
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
      ),
    );
  }
}
