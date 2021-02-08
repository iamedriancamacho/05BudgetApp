import 'package:budget/repositories/database_connection.dart';
import 'package:sqflite/sqflite.dart';

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
}
