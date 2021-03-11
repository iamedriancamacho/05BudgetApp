import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseConnection {
  setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'db_budget');
    var finaldb =
        await openDatabase(path, version: 1, onCreate: _onCreatingDatabase2);
    return finaldb;
  }

  _onCreatingDatabase2(Database database, int version) async {
    await database.execute(
        "CREATE TABLE CAT(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, total REAL NOT NULL, max REAL NOT NULL, firstDate TEXT, endDate TEXT)");

    await database.execute(
        "CREATE TABLE ITEM(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, datetime TEXT NOT NULL, amount REAL NOT NULL, catID INTEGER NOT NULL, week TEXT NOT NULL)");
  
     await database.execute(
        "CREATE TABLE DAYS(id INTEGER PRIMARY KEY AUTOINCREMENT, firstWeek TEXT NOT NULL, monday REAL NOT NULL,  tuesday REAL NOT NULL,  wednesday REAL NOT NULL, thursday REAL NOT NULL,friday REAL NOT NULL, saturday REAL NOT NULL, sunday REAL NOT NULL)");
  }
}
