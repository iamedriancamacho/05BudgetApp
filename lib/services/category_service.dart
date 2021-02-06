import 'package:budget/models/category.dart';
import 'package:budget/repositories/repository.dart';

class CategoryService {
  Repository _rep;

  CategoryService() {
    _rep = Repository();
  }

  //Creating data
  saveCategory(Category category) async {
    print(category.id);
    print(category.name);
    print(category.total);
    print(category.max);
    return await _rep.insertData('CAT', category.categoryMap());
  }

  //read data from table
  readCategories() async {
   return await _rep.readData('CAT');

  }
}
