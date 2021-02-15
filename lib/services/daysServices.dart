import 'package:budget/models/days.dart';
import 'package:budget/repositories/repository.dart';

class DaysService {
  Repository _rep;

  DaysService() {
    _rep = Repository();
  }

  //Creating data
  saveDays(Days days) async {
    print(days.id);
    print(days.firstWeek);
    print(days.monday);
    print(days.wednesday);
    return await _rep.insertData('DAYS', days.daysMap());
  }

  //read data from table
  readDays() async {
    return await _rep.readData('DAYS');
  }

  //read data by ID
  readDaysByID(daysID) async {
    return await _rep.readDataByID('DAYS', daysID);
  }

  updateDays(Days days) async {
    return await _rep.updateData('DAYS', days.daysMap());
  }

  deleteDays(int daysID) async {
    return await _rep.deleteDataByID('DAYS', daysID);
  }

  checkTable() async {
    return await _rep.checkExist('DAYS');
  }

  updateDaysValue(Days days,String firstWeek) async{
    return await _rep.updateDataByValue('DAYS',days.daysMap(),firstWeek);
  }
}
