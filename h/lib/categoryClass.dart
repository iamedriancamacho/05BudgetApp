
class CategoryClass {
  int id;
  String name;
  int budgetLimit;
  int current;

  categoryMap() {
    var map = Map<String, dynamic>();

    map['id'] = id;
    map['name'] = name;
    map['budgetLimit'] = budgetLimit;
    map['current'] = current;
    return map;

    
  }
}

List categoryName = [], categoryLimit = [], categoryCurrent = [];

CategoryClass x;
double perc;
List<CategoryClass> list = List<CategoryClass>();

 