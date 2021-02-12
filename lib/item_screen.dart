import 'package:budget/models/category.dart';
import 'package:budget/models/item.dart';
import 'package:budget/services/category_service.dart';
import 'package:budget/services/item_service.dart';
import 'package:flutter/material.dart';
import 'package:budget/widgets/radial_painter.dart';
import 'package:budget/helpers/color_helper.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:intl/intl.dart';

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
  int itemNumber = 20;
  double tempMoney = 0;
  var countMoney = 0;
  double percent;
  DateTime newDatetime;
  String date = "Add Date";
  @override
  void initState() {
    super.initState();
    getAllItems();
  }

  getAllItems() async {
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
        print('countMoney: $countMoney');
        print('nakasulod ko diri $itemList');
        for (int i = 0; i < countMoney; i++) {
          print('itemList.amount: ${itemList[i].amount}');
          tempMoney += itemList[i].amount;
        }
        print('tempMoney: $tempMoney');
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
      _cat.firstDate = widget.firstDate;
      _cat.endDate = widget.endDate;

      print("FirstDay = ${widget.firstDate}");
      print("SecondDay = ${widget.endDate}");

      var result2 = await _categoryService.updateCategory(_cat);
      print(result2);
      
      widget.updateCat(tempMoney, _cat.id, _cat.name, _cat.max, _cat.firstDate,
          _cat.endDate);
          
    }
  }

  _getDate() async {
    //DateTime date;
    newDatetime = await showRoundedDatePicker(
      context: context,
      initialDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
      borderRadius: 16,
      theme: ThemeData(primaryColor: Colors.green),
    );
    setState(() {
      date = DateFormat.yMMMMEEEEd().format(newDatetime);
      Navigator.pop(context);
      addItem();
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

                      var result = await itemService.saveItem(_item);
                      print(result);
                      if (result > 0) {
                        print('RESULT1 is $result');
                        // Navigator.pop(context);
                        //Navigator.pop(context); //idk ngano duha ka pop HUHUHU
                        //list.clear();
                        //getAllCategories();
                        //widget.updateCat(tempMoney);
                      }
                      print("TEMP MONEY: $tempMoney");
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
                                  } else {
                                    var result = await _itemService
                                        .deleteCategory(itemList[index].id);
                                    if (result > 0) {
                                      print('RESULT is $result');

                                      getAllItems();
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
