import 'package:budget/repositories/database_connection.dart';
import 'package:sqflite/sqflite.dart';

int count;

class Repository {
  DatabaseConnection _databaseConnection;

  Repository() {
    //initialize database connection
    _databaseConnection = DatabaseConnection();
  }

  static Database _database;

  //checks if database exists or not
  Future<Database> get finaldb async {
    if (_database != null) return _database;
    _database = await _databaseConnection.setDatabase();
    return _database;
  }

  //Inserting data to Table
  insertData(table, data) async {
    var connection = await finaldb;
    return await connection.insert(table, data);
  }

  //Read Data from Table
  readData(table) async {
    var connection = await finaldb;
    return await connection.query(table);
  }

  //read data from table by ID
  readDataByID(table, id) async {
    var connection = await finaldb;
    return await connection.query(table, where: 'id=?', whereArgs: [id]);
  }

//check if table exist
  checkExist(table) async {
    var connection = await finaldb;
    return count = Sqflite.firstIntValue(
        await connection.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  //list all category

  allCategory(table) async {
    var connection = await finaldb;
    return await connection
        .rawQuery("SELECT * FROM $table");
  }

  //update data from table
  updateData(table, data) async {
    var connection = await finaldb;
    return await connection
        .update(table, data, where: 'id=?', whereArgs: [data['id']]);
  }

  //delete data from table
  deleteDataByID(table, categoryID) async {
    var connection = await finaldb;
    return await connection
        .rawDelete("DELETE FROM $table WHERE id = $categoryID");
  }

// update specific data in a row
  updateDataByValue(table,data,value) async {
    var connection = await finaldb;
    return await connection
        .update(table, data, where: 'firstWeek=$value', whereArgs: [data['firstWeek']]);
  }
}
