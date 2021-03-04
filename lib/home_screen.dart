import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:budget/models/category.dart';
import 'package:budget/models/item.dart';
import 'package:budget/services/category_service.dart';
import 'package:budget/services/daysServices.dart';
import 'package:budget/services/item_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'item_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:budget/models/days.dart';

class HomeScreen extends StatefulWidget {
  final String title;

  HomeScreen({this.title});

  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  var _item = Item(); //accessing item method
  var _itemService = ItemService(); //accessing item service method
  var _category = Category(); //accessing category method
  var _categoryService = CategoryService(); //accessing catService;
  var category; //global var from _editCat
  int catNumber = 10; //for id
  var _days = Days(); // for accessing values inside days class
  var _dayService =
      DaysService(); // for accessing functions inside the dayservice class
  DateTime newDatetime;
  String firstDay,
      secondDay; // utility variables for getting the first week and second week
  String date = "Add Date"; // inital string value for adding dates
  DateTime firstDayWeek = new DateTime.now()
      .subtract(new Duration(days: DateTime.now().weekday - 1));
  //dropdown
  int x; //get ID of list
  String dropdownValue;
  List<String> catDropDownList = [];
  double percent;
  //end of variables

  @override
  void initState() {
    super.initState();
    checkItems(); //counts items
    getAllCategories(); //gets categories
    setDate(); // set the initial value for firstweek and second week
    initDays(); // initialize values for weekly spending chart
    getAllDays(); // appending values inside weekly spending chart to a list
  }

//set the initial value for firstweek and second week
  setDate() {
    firstDay = DateFormat.yMd().format(firstDayWeek);
    secondDay =
        DateFormat.yMd().format(firstDayWeek.add(new Duration(days: 6)));
    //  dis1 = firstDayWeek.add(new Duration(days: 7));
    dis2 = firstDayWeek.add(new Duration(days: 6));
  }

  //checks if items exist
  checkItems() async {
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

        itemList.add(itemModel);
      });
    });
  }

  //let user input date
  _getDate() async {
    bool go = false;
    //DateTime date;

    newDatetime = await showRoundedDatePicker(
      context: context,
      initialDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
      borderRadius: 16,
      theme: ThemeData(
        accentColor: Colors.green,
        dialogBackgroundColor: Colors.green[50],
        disabledColor: Colors.red,
      ),
      imageHeader: AssetImage("assets/images/novigrad.jpg"),
      description: "**You can only add dates from $firstDay to $secondDay**",
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
      // then if tapped, check if avail, if not then, it's allowed
      textPositiveButton: "SAVE",
      textNegativeButton: "",
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
    );
    setState(() {
      // if date is allowed then proceed in storing values
      if (go) {
        date = DateFormat.yMMMMEEEEd().format(newDatetime);
        //  day = DateFormat.EEEE().format(newDatetime).toString();
        Navigator.pop(context);
        addItem();
        getAllDays();
      } else
        date = "Add Date";
    });
  }

  //display categories
  //Async means that this function is asynchronous and you might need to wait a bit to get its result.
  getAllCategories() async {
    categoryList = List<Category>();
    var categories = await _categoryService.readCategories();
    int count = 0;
    catDropDownList.clear();
    categories.forEach((category) {
      var catModel = Category();
      catModel.id = category['id'];
      catModel.name = category['name'];
      catModel.total = category['total'];
      catModel.max = category['max'];
      catModel.firstDate = category['firstDate'];
      catModel.endDate = category['endDate'];
      print("FORST DAY $firstDay");
      globalList.add(catModel);
      if (firstDay == catModel.firstDate) {
        categoryList.add(catModel);
        catDropDownList.add(catModel.name);
      }
    });
    print("SuLOD $count");
  }

  initDays() async {
    int resultDays = await _dayService.checkTable();

    if (resultDays == 0) {
      print("FIRST TIME RUN!");
      _days.firstWeek = firstDay;
      _days.monday = 0.0;
      _days.tuesday = 0.0;
      _days.wednesday = 0.0;
      _days.thursday = 0.0;
      _days.friday = 0.0;
      _days.saturday = 0.0;
      _days.sunday = 0.0;
      var resultDays = await _dayService.saveDays(_days);
      print(resultDays);
      var readDays1 = await _dayService.readDays();
      readDays1.forEach((days) {
        print("INIT ID");
        daysIndex = days['id'];
        print("DAYSINDEX FOR FIRST");
        print("$daysIndex");
      });

      if (listDays.isEmpty) {
        print("INIT LIST DAYS");
        setState(() {
          listDays.add(_days);
        });
      }
    }
  }

  getAllDays() async {
    var days = await _dayService.readDays();

    setState(() {
      days.forEach((daysWeek) {
        var daysModel = Days();
        daysModel.id = daysWeek["id"];
        daysModel.firstWeek = daysWeek["firstWeek"];
        daysModel.monday = daysWeek["monday"];
        daysModel.tuesday = daysWeek["tuesday"];
        daysModel.wednesday = daysWeek["wednesday"];
        daysModel.thursday = daysWeek["thursday"];
        daysModel.friday = daysWeek["friday"];
        daysModel.saturday = daysWeek["saturday"];
        daysModel.sunday = daysWeek["sunday"];

        if (firstDay == daysModel.firstWeek) {
          chek = daysModel.monday;

          setState(() {
            listDays.clear();
            listDays.add(daysModel);
            daysIndex = daysWeek['id'];
            double total = daysModel.monday +
                daysModel.tuesday +
                daysModel.wednesday +
                daysModel.thursday +
                daysModel.friday +
                daysModel.saturday +
                daysModel.sunday;
            print("TOTAL $total");
            if (total == 0 || categoryList.length == 0) {
              mon = 0;
              tue = 0;
              wed = 0;
              thu = 0;
              fri = 0;
              sat = 0;
              sun = 0;
            } else {
              print("asd");
              mon = (daysModel.monday / total) * 100;
              tue = (daysModel.tuesday / total) * 100;
              wed = (daysModel.wednesday / total) * 100;
              thu = (daysModel.thursday / total) * 100;
              fri = (daysModel.friday / total) * 100;
              sat = (daysModel.saturday / total) * 100;
              sun = (daysModel.sunday / total) * 100;
            }
          });
        }
      });
    });
  }

// extracting the day in the date format "yMd"
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

// updating the values inside the weekly spending chart.
  updateWeek() async {
    var daysModel4 = Days();
    print("FIRST DAY $firstDay");
    var daysWeek1 = await _dayService.readDays();
    // print("CURRENT DAY ${widget.firstDate}");
    daysWeek1.forEach((days) {
      if (firstDay == days['firstWeek']) {
        if (getDayString(_item.datetime) == "Monday") {
          var temp = days['monday'];
          daysModel4.monday = temp + double.parse(itemAmount.text);
          daysModel4.id = days['id'];
          daysModel4.firstWeek = days['firstWeek'];
          daysModel4.tuesday = days['tuesday'];
          daysModel4.wednesday = days['wednesday'];
          daysModel4.thursday = days['thursday'];
          daysModel4.friday = days['friday'];
          daysModel4.saturday = days['saturday'];
          daysModel4.sunday = days['sunday'];
          print("DAYSMODEL MONDAY ${daysModel4.monday}");
        } else if (getDayString(_item.datetime) == "Tuesday") {
          var temp = days['tuesday'];
          daysModel4.tuesday = temp + double.parse(itemAmount.text);
          daysModel4.id = days['id'];
          daysModel4.firstWeek = days['firstWeek'];
          daysModel4.monday = days['monday'];
          daysModel4.wednesday = days['wednesday'];
          daysModel4.thursday = days['thursday'];
          daysModel4.friday = days['friday'];
          daysModel4.saturday = days['saturday'];
          daysModel4.sunday = days['sunday'];
          print("DAYSMODEL tue ${daysModel4.tuesday}");
        } else if (getDayString(_item.datetime) == "Wednesday") {
          var temp = days['wednesday'];
          daysModel4.wednesday = temp + double.parse(itemAmount.text);
          daysModel4.id = days['id'];
          daysModel4.firstWeek = days['firstWeek'];
          daysModel4.monday = days['monday'];
          daysModel4.tuesday = days['tuesday'];
          daysModel4.thursday = days['thursday'];
          daysModel4.friday = days['friday'];
          daysModel4.saturday = days['saturday'];
          daysModel4.sunday = days['sunday'];
          print("DAYSMODEL wed ${daysModel4.wednesday}");
        } else if (getDayString(_item.datetime) == "Thursday") {
          var temp = days['thursday'];
          daysModel4.thursday = temp + double.parse(itemAmount.text);
          daysModel4.id = days['id'];
          daysModel4.firstWeek = days['firstWeek'];
          daysModel4.monday = days['monday'];
          daysModel4.tuesday = days['tuesday'];
          daysModel4.wednesday = days['wednesday'];
          daysModel4.friday = days['friday'];
          daysModel4.saturday = days['saturday'];
          daysModel4.sunday = days['sunday'];
          print("DAYSMODEL thu ${daysModel4.thursday}");
        } else if (getDayString(_item.datetime) == "Friday") {
          var temp = days['friday'];
          daysModel4.friday = temp + double.parse(itemAmount.text);
          daysModel4.id = days['id'];
          daysModel4.firstWeek = days['firstWeek'];
          daysModel4.monday = days['monday'];
          daysModel4.tuesday = days['tuesday'];
          daysModel4.wednesday = days['wednesday'];
          daysModel4.thursday = days['thursday'];
          daysModel4.saturday = days['saturday'];
          daysModel4.sunday = days['sunday'];
          print("DAYSMODEL fri ${daysModel4.friday}");
        } else if (getDayString(_item.datetime) == "Saturday") {
          var temp = days['saturday'];
          daysModel4.saturday = temp + double.parse(itemAmount.text);
          daysModel4.id = days['id'];
          daysModel4.firstWeek = days['firstWeek'];
          daysModel4.monday = days['monday'];
          daysModel4.tuesday = days['tuesday'];
          daysModel4.wednesday = days['wednesday'];
          daysModel4.thursday = days['thursday'];
          daysModel4.friday = days['friday'];
          daysModel4.sunday = days['sunday'];
          print("DAYSMODEL sat ${daysModel4.saturday}");
        } else if (getDayString(_item.datetime) == "Sunday") {
          var temp = days['sunday'];
          daysModel4.sunday = temp + double.parse(itemAmount.text);
          daysModel4.id = days['id'];
          daysModel4.firstWeek = days['firstWeek'];
          daysModel4.monday = days['monday'];
          daysModel4.tuesday = days['tuesday'];
          daysModel4.wednesday = days['wednesday'];
          daysModel4.thursday = days['thursday'];
          daysModel4.saturday = days['saturday'];
          daysModel4.friday = days['friday'];
          print("DAYSMODEL sun ${daysModel4.sunday}");
        }
      }
    });
    var result2 = await _dayService.updateDays(daysModel4);
    print(result2);
    getAllDays();
  }

// for popup
  popUp(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            content: Text("Oops! Check your inputs again.",
                textAlign: TextAlign.left),
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

  //add item using category screen
  test(String value) async {
    int count = 0;

    var result3 = await _categoryService.readCategories();
    setState(() {
      result3.forEach((cat) {
        catAddModel.id = cat['id'];
        catAddModel.name = cat['name'];
        catAddModel.firstDate = cat['firstDate'];
        if (value == cat['name']) {
          addCatId = catAddModel.id;
          print(
              "COUNT $count \nID = ${catAddModel.id}\nNAME = ${catAddModel.name}\nFIRSTDATE = ${catAddModel.firstDate}");
        }

        count++;
      });
    });
  }

  addItem() {
    print("TAP CATDROP $catDropDownList");
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
              Container(
                width: MediaQuery.of(context).size.width / 1.4,
                child: DropdownButton<String>(
                  isExpanded: true,
                  //  value: dropdownValue,
                  icon: Icon(Icons.keyboard_arrow_down),
                  iconSize: 30,
                  style: TextStyle(color: Theme.of(context).accentColor),
                  underline: Container(
                    height: 2,
                    color: Theme.of(context).accentColor,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue = newValue;
                      Navigator.pop(context);
                      addItem();
                    });
                  },
                  items: catDropDownList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      onTap: () {
                        setState(() {
                          getAllCategories();
                          print("DROPDOWN $value");
                          //x = catDropDownList.indexOf(value);
                          test(value);
                        });
                      },
                      value: dropdownValue,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 20.0),
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
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
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
                    print("ALL CAT ${categoryList.length}");
                    //_item.id = 20 + ++temp;
                    if ((double.parse(itemAmount.text) +
                                globalList[addCatId].total) >
                            globalList[addCatId].max ||
                        double.parse(itemAmount.text) <= 0) {
                      popUp(context);
                    } else {
                      _item.name = itemName.text;
                      _item.amount = double.parse(itemAmount.text);
                      _item.datetime = date;
                      _item.catID = addCatId;

                      listDays.clear();
                      updateWeek();
                      getAllDays();
                      getAllCategories();
                      var catM = Category();

                      var result = await itemService.saveItem(_item);
                      print("CATADDID $addCatId");
                      var result3 = await _categoryService.readCategories();
                      result3.forEach((cat) {
                        catM.id = cat['id'];
                        if (addCatId == catM.id) {
                          _category.id = addCatId;
                          _category.max = globalList[addCatId].max;
                          _category.name = globalList[addCatId].name;
                          _category.total = double.parse(itemAmount.text) +
                              globalList[addCatId].total;
                          _category.firstDate = globalList[addCatId].firstDate;
                          _category.endDate = globalList[addCatId].endDate;
                        }
                      });
                      var result2 =
                          await _categoryService.updateCategory(_category);
                      getAllCategories();
                      print("RESULT FOR UPDATECAT = $result2");

                      if (result > 0) {
                        print(result);
                        //  getAllItems(_category);
                        /*
                        if (firstDay == categoryList[x].firstDate) {
                          _updateCatFromItem(
                              _category.total,
                              _category.id,
                              _category.name,
                              _category.max,
                              _category.firstDate,
                              _category.endDate);
                        }
*/
                        Navigator.pop(context);
                      }

                      itemAmount.text = ' ';
                      itemName.text = ' ';
                      date = "Add Date";
                    }
                  },
                ),
              ),
            ],
          );
        });
  }

  //progressbar for listview category
  Widget progressBar(double total, double max) {
    return LinearPercentIndicator(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      lineHeight: 15.0,
      percent: total / max,
      progressColor: Colors.orange,
      backgroundColor: Colors.grey,
    );
  }

  saveDays() async {
    bool go = false;
    var readDay = await _dayService.readDays();
    setState(() {
      readDay.forEach((daysWeek) {
        if (daysWeek['firstWeek'] != firstDay) {
          _days.firstWeek = firstDay;
          _days.monday = 0.0;
          _days.tuesday = 0.0;
          _days.wednesday = 0.0;
          _days.thursday = 0.0;
          _days.friday = 0.0;
          _days.saturday = 0.0;
          _days.sunday = 0.0;
          print("FIRST DAY $firstDay");
          print("ADDED ${_days.firstWeek}");
          go = true;
        } else {
          go = false;
          print("Already Exist");
        }
      });
    });
    if (go && listDays.isNotEmpty) {
      var resultDays = await _dayService.saveDays(_days);
      readDay.forEach((d) {
        print("INDECES");
        var temp = d['id'];
        print(temp);
      });
      print(resultDays);
    }
    //  print(resultDays);
  }

  //insert category
  Widget addCategory() {
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
                'Add Category',
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontFamily: 'Josefin',
                    fontSize: 20.0),
              ),
              SizedBox(height: 20.0),
              Container(
                width: 300,
                child: TextField(
                  controller: catName,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    labelText: "Enter a Category",
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
                  controller: catLimit,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    labelText: "Enter a Budget Limit",
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                alignment: Alignment.centerRight,
                child: FlatButton(
                  child: Text(
                    "SUBMIT",
                    style: TextStyle(fontSize: 17.0),
                  ),
                  onPressed: () async {
                    if (catName.text.isEmpty || catLimit.text.isEmpty) {
                      popUp(context);
                    } else {
                      //for checking
                      int temp = 0;
                      var categories = await _categoryService.readCategories();
                      categories.forEach((category) {
                        temp++;
                      });
                      if (double.parse(catLimit.text) <= 0) {
                        popUp(context);
                      } else {
                        //end of checking

                        _category.id = temp++;
                        //_category.firstDate;
                        //_category.endDate;
                        _category.name = catName.text;
                        _category.total = 0;
                        _category.max = double.parse(catLimit.text);
                        //print(_category.id);
                        print("ADD CAT FIRST DAY $firstDay");
                        _category.firstDate = firstDay;
                        _category.endDate = secondDay;
                        print("CATEGORY FIRST DAY ${_category.firstDate}");
                        print("CATEGORY SECOND DAY ${_category.endDate}");
                        var result =
                            await _categoryService.saveCategory(_category);
                        getAllCategories();
                        print(result);
                        catName.text = '';
                        catLimit.text = '';

                        saveDays();
                        getAllDays();
                        // add days

                        // end add days
                        Navigator.pop(context);
                      }
                    }
                  },
                ),
              ),
              catDropDownList.length > 0
                  ? FlatButton(
                      child: Text('I already have a category'),
                      onPressed: () {
                        print("I already $firstDay");
                        Navigator.pop(context);
                        addItem();
                      })
                  : Text(' '),
              SizedBox(height: 20.0),
            ],
          );
        });

    return Container();
  }

  //this is a method
  _editCategory(
      BuildContext context, categoryID, categoryName, categoryLimit) async {
    category = await _categoryService.readCategoriesByID(categoryID);
    // print('_editCategory ${category[0]['id']}');
    // print('_editCategory ${category[0]['name']}');
    // print('_editCategory ${category[0]['max']}');
    setState(() {
      catNameEdit.text = category[0]['name'] ?? 'NO Name';
      catLimitEdit.text = category[0]['max'].toString() ?? 'No Max';
    });
    _edit(context);
  }

//update category name
  _edit(BuildContext context) {
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
                  _category.id = category[0]['id'];
                  _category.name = catNameEdit.text;
                  //_category.firstDate;
                  //_category.endDate;
                  _category.total = category[0]['total'];
                  _category.max = double.parse(catLimitEdit.text);
                  _category.firstDate = firstDay;
                  _category.endDate = secondDay;
                  var result = await _categoryService.updateCategory(_category);
                  if (result > 0) {
                    print('RESULT is $result');
                    Navigator.pop(context);
                    Navigator.pop(context);
                    getAllCategories();
                  }
                },
              ),
            ],
            title: Text("Edit Category"),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: catNameEdit,
                    decoration: InputDecoration(
                      labelText: "Name",
                    ),
                  ),
                  TextField(
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    controller: catLimitEdit,
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

  _updateCatFromItem(double tempMoney, int id, String name, double max,
      String firstDate, String endDate) async {
    //var result1 = await _categoryService.readCategories();

    _category.id = id;
    _category.name = name;
    _category.total = tempMoney;
    _category.max = max;
    _category.firstDate = firstDay;
    _category.endDate = secondDay;

    print('_updateCat is here: $tempMoney');

    print('_category.total is: ${_category.total}');

    var result2 = await _categoryService.updateCategory(_category);
    setState(() {
      getAllCategories();
    });
    if (result2 > 0) {
      print('result2 is $result2');
    }
  }

  Widget chart(double perc, String day, double price) {
    // for the weekly chart

    return Column(
      children: <Widget>[
        AutoSizeText(
          "₱ $price",
          maxLines: 1,
        ),
        Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey[200],
                borderRadius: BorderRadius.all(Radius.elliptical(100, 50)),
              ),
              width: 15,
              height: 100,
            ),
            Container(
              //alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.elliptical(100, 50)),
              ),
              width: 15,
              height: perc,
            ),
          ],
        ),
        AutoSizeText(
          "$day",
          maxLines: 1,
        ),
      ],
    );
  }

  Widget barChart() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          listDays.length == 0 || categoryList.length == 0
              ? chart(0, "MON", 0)
              : chart(mon, "MON", listDays[0].monday),
          listDays.length == 0 || categoryList.length == 0
              ? chart(0, "TUE", 0)
              : chart(tue, "TUE", listDays[0].tuesday),
          listDays.length == 0 || categoryList.length == 0
              ? chart(0, "WED", 0)
              : chart(wed, "WED", listDays[0].wednesday),
          listDays.length == 0 || categoryList.length == 0
              ? chart(0, "THU", 0)
              : chart(thu, "THU", listDays[0].thursday),
          listDays.length == 0 || categoryList.length == 0
              ? chart(0, "FRI", 0)
              : chart(fri, "FRI", listDays[0].friday),
          listDays.length == 0 || categoryList.length == 0
              ? chart(0, "SAT", 0)
              : chart(sat, "SAT", listDays[0].saturday),
          listDays.length == 0 || categoryList.length == 0
              ? chart(0, "SUN", 0)
              : chart(sun, "SUN", listDays[0].sunday),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xffF1F3F6),
        appBar: AppBar(
          backgroundColor: Color(0xffF1F3F6),
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Simple Budget",
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
          leading: IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                print("appbar $firstDay");
                addCategory();
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            children: <Widget>[
              // Text('${itemList.length}'),
              SizedBox(height: 20.0),
              Center(
                child: Container(
                  height: 280.0,
                  width: MediaQuery.of(context).size.width / 1.2,
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(color: Colors.white, blurRadius: 10.0)
                  ]),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color(0xffF1F3F6),
                    ),
                    width: 270.0,
                    height: 280.0,
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 25.0),
                          Text(
                            "Weekly Spending",
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Theme.of(context).accentColor),
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.keyboard_arrow_left),
                                iconSize: 30.0,
                                onPressed: () {
                                  setState(() {
                                    mon = 0;
                                    tue = 0;
                                    wed = 0;
                                    thu = 0;
                                    fri = 0;
                                    sat = 0;
                                    sun = 0;
                                    // TO THE LEFT

                                    firstDayWeek = firstDayWeek
                                        .subtract(new Duration(days: 7));
                                    print("$firstDayWeek");
                                    dis1 = firstDayWeek
                                        .subtract(new Duration(days: 7));
                                    dis2 =
                                        firstDayWeek.add(new Duration(days: 6));
                                    firstDay =
                                        DateFormat.yMd().format(firstDayWeek);
                                    secondDay = DateFormat.yMd().format(
                                        firstDayWeek
                                            .add(new Duration(days: 6)));
                                    print("LEFT FIRST DAY <== $firstDay");
                                    print("LEFT SECOND DAY <== $secondDay");

                                    getAllCategories();
                                    getAllDays();
                                  });
                                },
                              ),
                              AutoSizeText(
                                '${DateFormat.yMMMd().format(firstDayWeek)} - ${DateFormat.yMMMd().format(firstDayWeek.add(new Duration(days: 6)))}',
                                maxLines: 1,
                                style: TextStyle(
                                    fontFamily: "Jose",
                                    fontSize: 15.0,
                                    color: Theme.of(context).accentColor),
                              ),
                           
                              IconButton(
                                icon: Icon(Icons.keyboard_arrow_right),
                                iconSize: 30.0,
                                onPressed: () {
                                  setState(() {
                                    mon = 0;
                                    tue = 0;
                                    wed = 0;
                                    thu = 0;
                                    fri = 0;
                                    sat = 0;
                                    sun = 0;

                                    // TO THE RIGHT

                                    firstDayWeek =
                                        firstDayWeek.add(new Duration(days: 7));
                                    dis1 =
                                        firstDayWeek.add(new Duration(days: 7));

                                    firstDay =
                                        DateFormat.yMd().format(firstDayWeek);
                                    secondDay = DateFormat.yMd().format(
                                        firstDayWeek
                                            .add(new Duration(days: 6)));
                                    dis2 =
                                        firstDayWeek.add(new Duration(days: 6));
                                    print("RIGHT FIRST DAY <== $firstDay");
                                    print("RIGHT SECOND DAY <== $secondDay");

                                    getAllCategories();
                                    getAllDays();
                                  });
                                },
                              ),
                               
                            ],
                          ),
                          //  chart(20.0),
                             barChart(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              categoryList.length != 0
                  ? Expanded(
                      child: ListView.builder(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          itemCount: categoryList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Dismissible(
                              //secondaryBG ni sha before pero no worries
                              background: Center(
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
                                  _editCategory(
                                      context,
                                      categoryList[index].id,
                                      categoryList[index].name,
                                      categoryList[index].max);
                                  // getCategories();
                                  _edit(context);
                                } else {
                                  print("left;");
                                }
                                //cannot delete category
                              },
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
                                      onTap: () {
                                        /*
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CategoryScreen(
                                                    firstDate:
                                                        categoryList[index]
                                                            .firstDate,
                                                    endDate: categoryList[index]
                                                        .endDate,
                                                    updateCat:
                                                        _updateCatFromItem,
                                                    catMax:
                                                        categoryList[index].max,
                                                    catID:
                                                        categoryList[index].id,
                                                    name: categoryList[index]
                                                        .name),
                                          ),
                                        );
                                        */
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CategoryScreen(
                                                      firstDate:
                                                          categoryList[index]
                                                              .firstDate,
                                                      endDate:
                                                          categoryList[index]
                                                              .endDate,
                                                      updateCat:
                                                          _updateCatFromItem,
                                                      catMax:
                                                          categoryList[index]
                                                              .max,
                                                      catID: categoryList[index]
                                                          .id,
                                                      name: categoryList[index]
                                                          .name)),
                                        ).then((value) => setState(() {}));
                                      },
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Text('${categoryList[index].id}'),
                                          AutoSizeText(
                                            "${categoryList[index].name}",
                                            maxLines: 1,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .accentColor,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 25.0),
                                          ),
                                          AutoSizeText(
                                              "₱ ${categoryList[index].total}/${categoryList[index].max}",
                                              maxLines: 1),
                                        ],
                                      ),

                                      subtitle: progressBar(
                                          categoryList[index].total,
                                          categoryList[index].max),

                                      /*
                                      subtitle: Text(
                                          "${categoryList[index].firstDate}"),
                                           */
                                      leading: Container(
                                        width: 50.0,
                                        height: 100.0,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.orange,
                                          foregroundColor: Colors.black,
                                          child: AutoSizeText(
                                            "${categoryList[index].name[0]}",
                                            maxLines: 1,
                                            style: TextStyle(fontSize: 30.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    )
                  : Text("No Categories Yet!")
            ],
          ),
        ),
      ),
    );
  }
}
