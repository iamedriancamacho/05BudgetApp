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

  //read data from table
  populateCategories() async {
    return await _rep.allCategory('CAT');
  }


  //read data from table by ID
  readCategoriesByID(categoryID) async {
    return await _rep.readDataByID('CAT', categoryID);
  }

  updateCategory(Category category) async{
    return await _rep.updateData('CAT', category.categoryMap());
  }

  deleteCategory(categoryID) async{
    return await _rep.deleteDataByID('CAT', categoryID);
  }

}
