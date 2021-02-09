import 'package:budget/models/item.dart';
import 'package:budget/services/item_service.dart';
import 'package:flutter/material.dart';
import 'package:budget/widgets/radial_painter.dart';
import 'package:budget/helpers/color_helper.dart';

class CategoryScreen extends StatefulWidget {
  final String name;
  final int catID;

  CategoryScreen({this.name, this.catID});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  var _item = Item();
  var _itemService = ItemService();
  var item;
  int itemNumber = 20;

  @override
  void initState() {
    super.initState();
    getAllItems();
  }

  getAllItems() async {
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
        }
      });
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
                    //for checking
                    int temp = 0;
                    var categories = await _itemService.readItem();
                    categories.forEach((category) {
                      temp++;
                    });
                    //end of checking
                    _item.id = itemNumber + temp++;
                    _item.name = itemName.text;
                    _item.amount = double.parse(itemAmount.text);
                    _item.datetime = 'insert datetime here';
                    _item.catID = widget.catID;

                    var result = await itemService.saveItem(_item);
                    print(result);
                    getAllItems();
                    Navigator.pop(context);
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
                  _item.id = item[0]['id'];
                  _item.name = itemNameEdit.text;
                  _item.datetime = " insert datetime here";
                  _item.amount = double.parse(itemLimitEdit.text);

                  var result = await _itemService.updateItem(_item);
                  if (result > 0) {
                    print('RESULT is $result');
                    Navigator.pop(context);
                    Navigator.pop(context); //idk ngano duha ka pop HUHUHU
                    //list.clear();
                    getAllItems();
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
    double totalAmountSpent = 0;
    // totalAmountSpent += expense.cost;
    totalAmountSpent += 0;
    var maxAmount = 0;
    final double amountLeft = maxAmount - totalAmountSpent;
    final double percent = amountLeft / maxAmount;
    return SafeArea(
      child: Scaffold(
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 2),
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: CustomPaint(
                    foregroundPainter: RadialPainter(
                      bgColor: Colors.grey[200],
                      lineColor: getColor(context, percent),
                      percent: percent,
                      width: 15.0,
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
                                        leading: Text('${itemList[index].id}'),
                                        subtitle: Text(
                                            'categoryID: ${itemList[index].catID} \n*dapat datetime ni sha*'),
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
