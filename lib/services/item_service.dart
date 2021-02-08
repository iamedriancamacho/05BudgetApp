import 'package:budget/models/item.dart';
import 'package:budget/repositories/repository.dart';

class ItemService {
  Repository _rep;

  ItemService() {
    _rep = Repository();
  }

  //Creating data
  saveItem(Item item) async {
    print(item.id);
    print(item.name);
    print(item.datetime);
    print(item.amount);
    print(item.catID);
    return await _rep.insertData('ITEM', item.itemMap());
  }

  //read data from table
  readItem() async {
    return await _rep.readData('ITEM');
  }
}
