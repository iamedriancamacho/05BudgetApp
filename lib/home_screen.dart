import 'package:flutter/material.dart';
import 'categoryClass.dart';
import 'package:flutter/widgets.dart';
import 'categoryFunctions.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  final catName = TextEditingController();
  final catLimit = TextEditingController();
  final catNameEdit = TextEditingController();
  final catLimitEdit = TextEditingController();
  var category = CategoryClass();
  var functions = CategoryFunctions();
  var _category;

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  getCategories() async {
    var categories = await functions.readCategory();
    setState(() {
      categories.forEach((category) {
        var catModel = CategoryClass();
        catModel.name = category['name'];
        catModel.budgetLimit = category['budgetLimit'];
        catModel.id = category['id'];
        catModel.current = category['current'];
        list.add(catModel);
      });
    });
  }

  Widget progressBar(int current, int limit) {
    return Container(
      padding: EdgeInsets.only(top: 15.0),
      child: LinearPercentIndicator(
        padding: EdgeInsets.only(right: 5.0),
        width: MediaQuery.of(context).size.width / 1.3,
        lineHeight: 8.0,
        percent: 0.5,
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
                    labelText: "Enter a Budget  Limit",
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
                  onPressed: () {
                    list.clear();
                    confirm();
                  },
                ),
              ),
            ],
          );
        });

    return Container();
  }

  double progressValue(double limit, double current) {
    if (limit == 0)
      perc = 0.0;
    else {
      perc = (current / limit) * 90;
    }
    return perc;
  }

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
                  setState(() async {
                    category.name = catNameEdit.text;
                    category.budgetLimit = int.parse(catLimitEdit.text);
                    category.id = _category[0]['id'];
                    var result = await functions.updateCategory(category);
                    list.clear();
                    getCategories();
                  });
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

  void confirm() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Add Category?"),
            actions: <Widget>[
              FlatButton(
                child: Text("No", style: TextStyle(fontSize: 20.0)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Yes", style: TextStyle(fontSize: 20.0)),
                onPressed: () async {
                  setState(() {
                    // category.add(CategoryClass("1", 1, 1));
                    category.name = catName.text;
                    category.budgetLimit = int.parse(catLimit.text);
                    category.current = 0;
                    var result = functions.addCategory(category);
                    print("db ${result.toString()}");
                    Navigator.pop(context);
                    progressValue(double.parse(catLimit.text.toString()), 23);
                    getCategories();
                  });
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
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
                list.length != 0
                    ? Expanded(
                        child: ListView.builder(
                            padding: EdgeInsets.all(16.0),
                            shrinkWrap: true,
                            itemCount: list.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Dismissible(
                                key: UniqueKey(),
                                onDismissed: (direction) async {
                                  if (direction.toString() ==
                                      "DismissDirection.endToStart") {
                                    edit(context);
                                    getCategories();
                                  } else {
                                    var result = await functions
                                        .deleteCategory(list[index].id);

                                    list.clear();
                                    getCategories();
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
                                      title: Text(
                                        "${list[index].name}",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 25.0),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          progressBar(list[index].current,
                                              list[index].budgetLimit),
                                          Text(
                                              "${list[index].current}/${list[index].budgetLimit}"),
                                        ],
                                      ),
                                      isThreeLine: true,

                                      // trailing: Text(
                                      //   "${list[index].current}/${list[index].budgetLimit}",
                                      //   style: TextStyle(
                                      //       fontWeight: FontWeight.w300),
                                      // ),
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
