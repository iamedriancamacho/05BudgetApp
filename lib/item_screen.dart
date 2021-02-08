import 'package:budget/models/item.dart';
import 'package:budget/services/item_service.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  final String name;
  final int catID;

  CategoryScreen({this.name, this.catID});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Item> _itemList = List<Item>();
  int itemNumber;

  @override
  void initState() {
    super.initState();
    getAllItems();
    itemNumber = 200;
  }

  final itemName = TextEditingController();
  final itemAmount = TextEditingController();
  var _item = Item();
  var _itemService = ItemService();

  getAllItems() async {
    _itemList = List<Item>();
    var items = await _itemService.readItem();
    setState(() {
      items.forEach((_item) {
        var itemModel = Item();
        itemModel.name = _item['name'];
        itemModel.datetime = _item['datetime'];
        itemModel.amount = _item['amount'];
        itemModel.catID = _item['catID'];
        itemModel.id = _item['id'];

        if (itemModel.id == null)
          itemNumber++;
        else {
          itemModel.id = itemNumber++;
        }
        print('my getAllItems is ${itemModel.id}');
        _itemList.add(itemModel);
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
                    setState(() {
                      _item.id = itemNumber;
                      print('my SUBMIT is ${_item.id}');
                      _item.name = itemName.text;
                      //insert datetime here
                      _item.amount = double.parse(itemAmount.text);
                      _item.catID = widget.catID;

                      var result = _itemService.saveItem(_item);
                      print(result);
                      getAllItems();

                      // category.add(CategoryClass("1", 1, 1));
                      // category.name = catName.text;
                      // category.budgetLimit = int.parse(catLimit.text);
                      // category.current = 0;

                      // var result = functions.addCategory(category);
                      // print("db ${result.toString()}");
                      // Navigator.pop(context);
                      // progressValue(double.parse(catLimit.text.toString()), 23);
                      // getCategories();
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          );
        });
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("${widget.name}"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            iconSize: 30.0,
            onPressed: () {
              addItem();
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
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _itemList.length != 0
                  ? ListView.builder(
                      padding: EdgeInsets.all(16.0),
                      shrinkWrap: true,
                      itemCount: _itemList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Dismissible(
                          key: UniqueKey(),
                          onDismissed: (direction) async {
                            if (direction.toString() ==
                                "DismissDirection.endToStart") {
                              //edit(context);
                              // getCategories();
                            } else {
                              // var result = await functions
                              //     .deleteCategory(list[index].id);
                              //
                              // list.clear();
                              // getCategories();
                            }
                          },
                          child: Container(
                            height: 110.0,
                            width: MediaQuery.of(context).size.width,
                            child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              color: Color(0xffF1F3F6),
                              child: ListTile(
                                // shape: ,
                                minVerticalPadding: 20.0,
                                onTap: () {},
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${_itemList[index].name}",
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 25.0),
                                    ),
                                    // Text(
                                    //     "${_itemList[index].total}/${_categoryList[index].max}"),
                                  ],
                                ),
                                subtitle: Text('Date here please ty'),
                                trailing: Text("${_itemList[index].amount}"),
                                leading: Text('${_itemList[index].id}'),
                              ),
                            ),
                          ),
                        );
                      })
                  : Text("No Categories Yet!"),
            ),
          ],
        ),
      ),
    );
  }
}
