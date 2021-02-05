import 'package:sqflite/sqflite.dart';
import 'categoryClass.dart';
import 'dbFunctions.dart';

class CategoryFunctions {
  DatabaseFunctions dbFunc;
  CategoryFunctions() {
    dbFunc = DatabaseFunctions();
  }

  addCategory(CategoryClass category) async {
    return await dbFunc.insertData('categories', category.categoryMap());
  }

  readCategory() async {
    return await dbFunc.readData('categories');
  }

  deleteCategory(id) async {
    return await dbFunc.deleteData('categories', id);
  }

  updateCategory(CategoryClass catClass) async {
    return await dbFunc.updateData('categories', catClass.categoryMap());
  }
}
