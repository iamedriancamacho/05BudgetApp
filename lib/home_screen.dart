import 'package:budget/models/category.dart';
import 'package:budget/services/category_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'item_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  final catName = TextEditingController();
  final catLimit = TextEditingController();

  final catNameEdit = TextEditingController();
  final catLimitEdit = TextEditingController();

  var _category = Category();
  var _categoryService = CategoryService();
  int catNumber;

  List<Category> _categoryList = List<Category>();
  @override
  void initState() {
    super.initState();
    getAllCategories();
    catNumber=100;

  }

  getAllCategories() async {
    _categoryList = List<Category>();
    var categories = await _categoryService.readCategories();
    setState(() {
      categories.forEach((category) {
        var catModel = Category();
        catModel.id = category['id'];
        catModel.name = category['name'];
        catModel.total = category['total'];
        catModel.max = category['max'];
        _categoryList.add(catModel);
      });
    });
  }

  // getCategories() async {
  //   var categories = await functions.readCategory();
  //   setState(() {
  //     categories.forEach((category) {
  //       var catModel = CategoryClass();
  //       catModel.name = category['name'];
  //       catModel.budgetLimit = category['budgetLimit'];
  //       catModel.id = category['id'];
  //       catModel.current = category['current'];
  //       list.add(catModel);
  //     });
  //   });
  // }

  Widget progressBar(double total, double max) {
    return Container(
      padding: EdgeInsets.only(top: 15.0),
      child: LinearPercentIndicator(
        padding: EdgeInsets.only(right: 5.0),
        width: MediaQuery.of(context).size.width / 1.3,
        lineHeight: 8.0,
        percent: total / max,
        progressColor: Colors.orange,
        backgroundColor: Colors.grey,
      ),
    );
  }

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
                    // catList.clear();
                    setState(() {
                      _category.id = catNumber++;
                      _category.name = catName.text;
                      _category.total = 50;
                      _category.max = double.parse(catLimit.text);
                      var result = _categoryService.saveCategory(_category);
                      print(result);

                      getAllCategories();

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

  // double progressValue(double limit, double current) {
  //   if (limit == 0)
  //     perc = 0.0;
  //   else {
  //     perc = (current / limit) * 90;
  //   }
  //   return perc;
  // }

  Widget deleteDesign() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.red,
      ),
    );
  }

  edit(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                color: Colors.green,
                onPressed: () {
                  // setState(() async {
                  //   _category.name = catNameEdit.text;
                  //    category.budgetLimit = int.parse(catLimitEdit.text);
                  //    _category.id = _category[0]['id'];
                  //    var result = await functions.updateCategory(category);
                  //    list.clear();
                  //    getCategories();
                  // });
                },
                child: Text("Update"),
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
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.grey[200],
                  ),
                  width: 270.0,
                  height: 250.0,
                  //
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 10.0),
                        Text(
                          "Weekly Spending",
                          style: TextStyle(
                              fontFamily: "Jose",
                              fontSize: 20.0,
                              color: Theme.of(context).accentColor),
                        ),
                      ],
                    ),
                  ),
                ),
                _categoryList.length != 0
                    ? Expanded(
                        child: ListView.builder(
                            padding: EdgeInsets.all(16.0),
                            shrinkWrap: true,
                            itemCount: _categoryList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Dismissible(
                                key: UniqueKey(),
                                onDismissed: (direction) async {
                                  if (direction.toString() ==
                                      "DismissDirection.endToStart") {
                                    edit(context);
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
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CategoryScreen(
                                                  catID: _categoryList[index].id,
                                                    name: _categoryList[index]
                                                        .name),
                                          ),
                                        );
                                      },
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${_categoryList[index].name}",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .accentColor,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 25.0),
                                          ),
                                          Text(
                                              "${_categoryList[index].total}/${_categoryList[index].max}"),
                                        ],
                                      ),
                                      subtitle: progressBar(
                                          _categoryList[index].total,
                                          _categoryList[index].max),
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
      ),
    );
  }
}
