class Category{
  int id;
  String name;
  double total;
  double max;

  categoryMap() {
    var map = Map<String, dynamic>();

    map['id'] = id;
    map['name'] = name;
    map['total'] = total;
    map['max'] = max;
    return map;
  }
}
