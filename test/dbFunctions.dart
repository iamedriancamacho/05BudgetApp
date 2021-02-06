// import 'dart:async';
// import 'file:///E:/BSIT_3/Mobile_1/05BudgetApp/lib/repositories/database_connection.dart';
// // import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
// // import 'package:path_provider/path_provider.dart';
//
// class DatabaseFunctions {
//   DatabaseConnection db;
//   DatabaseFunctions() {
//     db = DatabaseConnection();
//   }
//
//   static Database _db;
//
//   Future<Database> get finaldb async {
//     if (_db != null) return _db;
//     _db = await db.setDatabase();
//     return _db;
//   }
//
//   insertData(table, data) async {
//     var connection = await finaldb;
//     return await connection.insert(table, data);
//   }
//
//   readData(table) async {
//     var connection = await finaldb;
//     return await connection.query(table);
//   }
//
//   deleteData(table, id) async {
//     var connection = await finaldb;
//     return await connection.rawDelete("DELETE FROM $table WHERE id = $id");
//   }
//
//   updateData(table, data) async {
//     var connection = await finaldb;
//     return await connection.update(table, data,where: 'id=?',whereArgs: [data['id']]);
//   }
// }
