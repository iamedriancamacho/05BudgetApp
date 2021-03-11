// class CategoryClass {
//   int id;
//   String name;
//   int budgetLimit;
//   int current;
//
//   categoryMap() {
//     var map = Map<String, dynamic>();
//
//     map['id'] = id;
//     map['name'] = name;
//     map['budgetLimit'] = budgetLimit;
//     map['current'] = current;
//     return map;
//   }
// }
//
// //idk wtf are these
// List categoryName = [], categoryLimit = [], categoryCurrent = [];
//
// CategoryClass x;
// double perc;
// List<CategoryClass> list = List<CategoryClass>();
    /*
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
                      checkDrop = true;
                      addItem();
                    });
                  },
                  items: catDropDownList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      onTap: () {
                        setState(() {
                          dropdownValue = value;
                          //getAllCategories();
                          print("DROPDOWN $value");
                          //x = catDropDownList.indexOf(value);
                          test(value);
                        });
                      },
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
                  */