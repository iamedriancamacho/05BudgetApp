class Days {
  int id;
  String firstWeek;
  double monday;
  double tuesday;
  double wednesday;
  double thursday;
  double friday;
  double saturday;
  double sunday;
  daysMap() {
    var map = Map<String, dynamic>();

    map['id'] = id;
    map['firstWeek'] = firstWeek;
    map['monday'] = monday;
    map['tuesday'] = tuesday;
    map['wednesday'] = wednesday;
    map['thursday'] = thursday;
    map['friday'] = friday;
    map['saturday'] = saturday;
    map['sunday'] = sunday;

    return map;
  }
}

List<Days> listDays = List<Days>();
double chek = 0;
double mon = 0.0,
    tue = 0.0,
    wed = 0.0,
    thu = 0.0,
    fri = 0.0,
    sat = 0.0,
    sun = 0.0;
int daysIndex;
int lengthCat = 0;
bool content = false;
DateTime dis1, dis2;
String daysUpdate, firstDay;
