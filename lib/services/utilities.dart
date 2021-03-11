/*

  setState(() {
      daysWeek1.forEach((days) {
        if (widget.firstDate == days['firstWeek']) {
          oldDate = getDayString(oldDate).toLowerCase();
          newDate = getDayString(newDate).toLowerCase();
          print("OLD DATE = $oldDate NEW DATE = $newDate");
          temp = days[oldDate];
          tempAdd = days[newDate] + amount;
          if (newDate == 'monday') {
            daysModel3.monday = tempAdd;
            daysModel3.id = days['id'];
            daysModel3.firstWeek = days['firstWeek'];
            daysModel3.tuesday = days['tuesday'];
            daysModel3.wednesday = days['wednesday'];
            daysModel3.thursday = days['thursday'];
            daysModel3.friday = days['friday'];
            daysModel3.saturday = days['saturday'];
            daysModel3.sunday = days['sunday'];
          } else if (newDate == 'tuesday') {
            daysModel3.monday = tempAdd;
            daysModel3.id = days['id'];
            daysModel3.firstWeek = days['firstWeek'];
            daysModel3.monday = days['monday'];
            daysModel3.wednesday = days['wednesday'];
            daysModel3.thursday = days['thursday'];
            daysModel3.friday = days['friday'];
            daysModel3.saturday = days['saturday'];
            daysModel3.sunday = days['sunday'];
          } else if (newDate == 'wednesday') {
            daysModel3.wednesday = tempAdd;
            daysModel3.id = days['id'];
            daysModel3.firstWeek = days['firstWeek'];
            daysModel3.monday = days['monday'];
            daysModel3.tuesday = days['tuesday'];
            daysModel3.thursday = days['thursday'];
            daysModel3.friday = days['friday'];
            daysModel3.saturday = days['saturday'];
            daysModel3.sunday = days['sunday'];
          } else if (newDate == 'thursday') {
            daysModel3.thursday = tempAdd;
            daysModel3.id = days['id'];
            daysModel3.firstWeek = days['firstWeek'];
            daysModel3.monday = days['monday'];
            daysModel3.tuesday = days['tuesday'];
            daysModel3.wednesday = days['wednesday'];
            daysModel3.friday = days['friday'];
            daysModel3.saturday = days['saturday'];
            daysModel3.sunday = days['sunday'];
          } else if (newDate == 'friday') {
            daysModel3.friday = tempAdd;
            daysModel3.id = days['id'];
            daysModel3.firstWeek = days['firstWeek'];
            daysModel3.monday = days['monday'];
            daysModel3.tuesday = days['tuesday'];
            daysModel3.wednesday = days['wednesday'];
            daysModel3.thursday = days['thursday'];
            daysModel3.saturday = days['saturday'];
            daysModel3.sunday = days['sunday'];
          } else if (newDate == 'saturday') {
            daysModel3.saturday = tempAdd;
            daysModel3.id = days['id'];
            daysModel3.firstWeek = days['firstWeek'];
            daysModel3.monday = days['monday'];
            daysModel3.tuesday = days['tuesday'];
            daysModel3.wednesday = days['wednesday'];
            daysModel3.thursday = days['thursday'];
            daysModel3.friday = days['friday'];
            daysModel3.sunday = days['sunday'];
          } else if (newDate == 'sunday') {
            daysModel3.sunday = tempAdd;
            daysModel3.id = days['id'];
            daysModel3.firstWeek = days['firstWeek'];
            daysModel3.monday = days['monday'];
            daysModel3.tuesday = days['tuesday'];
            daysModel3.wednesday = days['wednesday'];
            daysModel3.thursday = days['thursday'];
            daysModel3.saturday = days['saturday'];
            daysModel3.friday = days['friday'];
          }
        }
      });
    });
    // add new date
    var result3 = await _daysService.updateDays(daysModel3);
    getAllDays();
    print(result2 + result3);

    */