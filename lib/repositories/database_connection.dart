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
        "CREATE TABLE CAT(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, total REAL NOT NULL, max REAL NOT NULL)");

    await database.execute(
        "CREATE TABLE ITEM(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, datetime TEXT, amount REAL, catID INTEGER)");
  }

// _onCreatingDatabase3(Database database, int version) async {
//   await database.execute(
//       "CREATE TABLE ITEM(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, date TEXT NOT NULL, amount REAL NOT NULL, FOREIGN KEY(catID) REFERENCES CAT(id))");
// }
}
