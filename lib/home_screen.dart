import 'package:budget/models/category.dart';
import 'package:budget/services/category_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'item_screen.dart';
import 'package:flutter/cupertino.dart';

class HomeScreen extends StatefulWidget {
  final String title;

  HomeScreen({this.title});

  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  //textfields
  final catName = TextEditingController();
  final catLimit = TextEditingController();

  //edit textfields
  final catNameEdit = TextEditingController();
  final catLimitEdit = TextEditingController();

  var _category = Category(); //var used for accessing category method
  var _categoryService = CategoryService(); //var used for accessing catService;
  var category; //global var from _editCat
  int catNumber = 0; //for id
  List<Category> _categoryList = List<Category>(); //list

  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  getAllCategories() async {
    _categoryList = List<Category>();
    var categories = await _categoryService.readCategories();

    setState(() {
      categories.forEach((category) {
        var catModel = Category();
        catModel.id = category['id'];
        if (catModel.id == null) {
          print('nisulod sa if catModel.id == null');
          catNumber++;
        } else {
          print('nisulod sa else');
          catModel.id = category['id'];
        }
        print('my ID is ${catModel.id}');
        catModel.name = category['name'];
        catModel.total = category['total'];
        catModel.max = category['max'];
        _categoryList.add(catModel);
      });
    });
  }

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
                    //for checking
                    int temp = 0;
                    var categories = await _categoryService.readCategories();
                    categories.forEach((category) {
                      temp++;
                    });

                    //end of checking
                    _category.id = temp++;
                    _category.name = catName.text;
                    _category.total = 2;
                    _category.max = double.parse(catLimit.text);
                    //print(_category.id);
                    var result = await _categoryService.saveCategory(_category);
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
                  //insert something here
                },
              ),
              FlatButton(
                child: Text("Update"),
                color: Colors.green,
                onPressed: () async {
                  _category.id = category[0]['id'];
                  _category.name = catNameEdit.text;
                  _category.total = 0;
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
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.grey[200],
                ),
                width: 270.0,
                height: 250.0,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 10.0),
                      Text(
                        "Weekly Spending",
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Theme.of(context).accentColor),
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.arrow_back),
                            iconSize: 30.0,
                            onPressed: () {},
                          ),
                          Text(
                            'Feb 10.2020 - Feb 16.2020',
                            style: TextStyle(
                                fontFamily: "Jose",
                                fontSize: 20.0,
                                color: Theme.of(context).accentColor),
                          ),
                          IconButton(
                            icon: Icon(Icons.arrow_forward),
                            iconSize: 30.0,
                            onPressed: () {},
                          ),
                        ],
                      ),
                      SizedBox(height: 30.0),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   crossAxisAlignment: CrossAxisAlignment.end,
                      //   children: <Widget>[
                      //     Bar(
                      //       label: 'Su',
                      //     ),
                      //     Bar(
                      //       label: 'Mo',
                      //     ),
                      //     Bar(
                      //       label: 'Tu',
                      //     ),
                      //     Bar(
                      //       label: 'We',
                      //     ),
                      //     Bar(
                      //       label: 'Th',
                      //     ),
                      //     Bar(
                      //       label: 'Fr',
                      //     ),
                      //     Bar(
                      //       label: 'Sa',
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
              _categoryList.length != 0
                  ? Expanded(
                      child: ListView.builder(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          //shrinkWrap: true,
                          itemCount: _categoryList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Dismissible(
                              background: Container(
                                padding: EdgeInsets.only(right: 20.0),
                                color: Colors.orange,
                                child: Icon(
                                  Icons.create,
                                  size: 35.0,
                                  color: Theme.of(context).accentColor,
                                ),
                                alignment: Alignment.centerRight,
                              ),
                              key: UniqueKey(),
                              onDismissed: (direction) async {
                                if (direction.toString() ==
                                    "DismissDirection.endToStart") {
                                  _editCategory(
                                      context,
                                      _categoryList[index].id,
                                      _categoryList[index].name,
                                      _categoryList[index].max);
                                  // getCategories();
                                  _edit(context);
                                } else {
                                  // var result = await functions
                                  //     .deleteCategory(list[index].id);
                                  //
                                  // list.clear();
                                  // getCategories();
                                }
                              },
                              child: Card(
                                child: Card(
                                  margin: EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                                 borderOnForeground: true,
                                  elevation: 10,
                                  semanticContainer: true,
                                  shadowColor: Color(0xffF1F3F6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  color: Color(0xffF1F3F6),
                                  child: ListTile(
                                    // shape: ,
                                    //minVerticalPadding: 20.0,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CategoryScreen(
                                              catID: _categoryList[index].id,
                                              name: _categoryList[index].name),
                                        ),
                                      );
                                    },
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('${_categoryList[index].id}'),
                                        Text(
                                          "${_categoryList[index].name}",
                                          style: TextStyle(
                                              color:
                                                  Theme.of(context).accentColor,
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
    );
  }
}
