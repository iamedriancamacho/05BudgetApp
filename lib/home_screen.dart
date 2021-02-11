import 'package:budget/models/category.dart';
import 'package:budget/models/item.dart';
import 'package:budget/services/category_service.dart';
import 'package:budget/services/item_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'item_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';

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
  DateTime currentWeek = new DateTime.now();

  //dropdown
  int x; //get ID of list
  String dropdownValue;
  List<String> catDropDownList = [];

  //end of variables

  @override
  void initState() {
    super.initState();
    checkItems(); //counts items
    getAllCategories(); //gets categories
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

  //display categories
  //Async means that this function is asynchronous and you might need to wait a bit to get its result.
  getAllCategories() async {
    categoryList = List<Category>();
    var categories = await _categoryService.readCategories();

    catDropDownList.clear();
    setState(() {
      categories.forEach((category) {
        var catModel = Category();
        catModel.id = category['id'];
        catModel.name = category['name'];

        catDropDownList.add(catModel.name);
        print('my itemList is ${catModel.name}');

        catModel.total = category['total'];
        catModel.max = category['max'];
        categoryList.add(catModel);
      });

      print('catDropdownlist.length: ${catDropDownList.length}');
    });
  }

  popUp(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            content:
                Text("This exceeds the budget limit. You can't add this item."),
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
  addItem() {
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
                  value: dropdownValue,
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
                        x = catDropDownList.indexOf(value);
                        print('onTap: $x');
                      },
                      value: value,
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
                child: TextField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    labelText: "Date",
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                  ),
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
                    //_item.id = 20 + ++temp;
                    if ((double.parse(itemAmount.text) +
                            categoryList[x].total) >
                        categoryList[x].max) {
                      popUp(context);
                    } else {
                      _item.name = itemName.text;
                      _item.amount = double.parse(itemAmount.text);
                      _item.datetime = 'insert datetime here';
                      _item.catID = x;

                      _category.id = x;
                      _category.max = categoryList[x].max;
                      _category.name = categoryList[x].name;
                      _category.total =
                          double.parse(itemAmount.text) + categoryList[x].total;
                      print('_category.total is: ${_category.total}');

                      var result = await itemService.saveItem(_item);
                      var result2 =
                          await _categoryService.updateCategory(_category);
                      if (result > 0) {
                        print(result);
                        print(result2);
                        print('home_screen result is $result');
                        _updateCatFromItem(_category.total, _category.id,
                            _category.name, _category.max);
                        Navigator.pop(context);
                      }
                      itemAmount.text = ' ';
                      itemName.text = ' ';
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
      lineHeight: 8.0,
      percent: total / max,
      progressColor: Colors.orange,
      backgroundColor: Colors.grey,
    );
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
                    //for checking
                    int temp = 0;
                    var categories = await _categoryService.readCategories();
                    categories.forEach((category) {
                      temp++;
                    });
                    //end of checking
                    _category.id = temp++;
                    _category.name = catName.text;
                    _category.total = 0;
                    _category.max = double.parse(catLimit.text);
                    //print(_category.id);
                    var result = await _categoryService.saveCategory(_category);
                    print(result);
                    catName.text = '';
                    catLimit.text = '';
                    getAllCategories();

                    Navigator.pop(context);
                  },
                ),
              ),
              catDropDownList.length > 0
                  ? FlatButton(
                      child: Text('I already have a category'),
                      onPressed: () {
                        Navigator.pop(context);
                        addItem();
                      })
                  : Text(':)'),
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
                  //Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Update"),
                color: Colors.green,
                onPressed: () async {
                  _category.id = category[0]['id'];
                  _category.name = catNameEdit.text;
                  _category.total = category[0]['total'];
                  _category.max = double.parse(catLimitEdit.text);

                  var result = await _categoryService.updateCategory(_category);
                  if (result > 0) {
                    print('RESULT is $result');
                    Navigator.pop(context);
                    Navigator.pop(context); //idk ngano duha ka pop HUHUHU
                    //list.clear();
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

  void _updateCatFromItem(
      double tempMoney, int id, String name, double max) async {
    print('_updateCat is here: $tempMoney');

    _category.id = id;
    _category.name = name;
    _category.total = tempMoney;
    _category.max = max;
    print('_category.total is: ${_category.total}');

    var result2 = await _categoryService.updateCategory(_category);
    if (result2 > 0) {
      print('result2 is $result2');
      setState(() {
        getAllCategories();
      });
    }
  }

  Widget chart(perc) {
    // for the weekly chart
    return Expanded(
      child: Column(
        children: <Widget>[
          Text(""),
        ],
      ),
    );
    /*
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.elliptical(100, 50)),
          ),
          width: 10,
          height: 100,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.all(Radius.elliptical(100, 50)),
          ),
          width: 10,
          height: perc,
        ),
      ],
    );
    */
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
                addCategory();
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            children: <Widget>[
              Text('${itemList.length}'),
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
                                    currentWeek =
                                        currentWeek.subtract(Duration(days: 6));
                                    print("${currentWeek.day}");
                                  });
                                },
                              ),
                              AutoSizeText(
                                '${DateFormat.yMd().format(currentWeek)} - ${DateFormat.yMd().format(currentWeek.add(Duration(days: 6)))}',
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
                                    currentWeek =
                                        currentWeek.add(Duration(days: 6));
                                  });
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Column(
                                children: <Widget>[],
                              ),
                            ],
                          ),
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
                                  //cannot delete category
                                }
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
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CategoryScreen(
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
                                      },
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('${categoryList[index].id}'),
                                          Text(
                                            "${categoryList[index].name}",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .accentColor,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 25.0),
                                          ),
                                          Text(
                                              "₱ ${categoryList[index].total}/${categoryList[index].max}"),
                                        ],
                                      ),

                                      subtitle: progressBar(
                                          categoryList[index].total,
                                          categoryList[index].max),
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
