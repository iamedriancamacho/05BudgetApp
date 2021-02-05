import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseConnection {
  setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'test3');
    var finaldb =
        await openDatabase(path, version: 1, onCreate: onCreatingDatabase);
    return finaldb;
  }

  onCreatingDatabase(Database database, int version) async {
    await database.execute(
        "CREATE TABLE categories(id INTEGER PRIMARY KEY, name TEXT, budgetLimit INTEGER, current INTEGER)");
  }

  
}
