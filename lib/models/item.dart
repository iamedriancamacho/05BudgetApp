class Item {
  int id;
  String name;
  String datetime;
  double amount;
  int catID;

  itemMap() {
    var map = Map<String, dynamic>();

    map['id'] = id;
    map['catID'] = catID;
    map['name'] = name;
    map['datetime'] = datetime;
    map['amount'] = amount;

    return map;
  }
}


int tempID;