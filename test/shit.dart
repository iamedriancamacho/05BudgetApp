 /*
  total += itemList[i].amount;
          daysWeek.forEach((days) {
            print("days[firstweek] == ${days['firstWeek']}");
            if (widget.firstDate == days['firstWeek']) {
              if (getDayString(itemList[i].datetime) == "Monday") {
                var temp = days['monday'];
                print("DB ==> $temp");
                daysModel.monday = temp + total;
                daysModel.tuesday = days['tuesday'];
                daysModel.wednesday = days['wednesday'];
                daysModel.thursday = days['thursday'];
                daysModel.friday = days['friday'];
                daysModel.saturday = days['saturday'];
                daysModel.sunday = days['sunday'];
                daysModel.id = days['id'];
                daysModel.firstWeek = days['firstWeek'];
                print("DAYSMODEL MONDAY ${daysModel.monday}");
              } else if (getDayString(itemList[i].datetime) == "Tuesday") {
                total += itemList[i].amount;
                daysModel.tuesday = days['tuesday'];
                daysModel.tuesday += total;
                daysModel.monday = days['monday'];
                daysModel.wednesday = days['wednesday'];
                daysModel.thursday = days['thursday'];
                daysModel.friday = days['friday'];
                daysModel.saturday = days['saturday'];
                daysModel.sunday = days['sunday'];
                daysModel.id = days['id'];
                daysModel.firstWeek = days['firstWeek'];
              } else if (getDayString(itemList[i].datetime) == "Wednesday") {
                total += itemList[i].amount;
                daysModel.wednesday = days['wednesday'];
                daysModel.wednesday += total;
                daysModel.monday = days['monday'];
                daysModel.tuesday = days['tuesday'];
                daysModel.thursday = days['thursday'];
                daysModel.friday = days['friday'];
                daysModel.saturday = days['saturday'];
                daysModel.sunday = days['sunday'];
                daysModel.id = days['id'];
                daysModel.firstWeek = days['firstWeek'];
              } else if (getDayString(itemList[i].datetime) == "Thursday") {
                total += itemList[i].amount;
                daysModel.thursday = days['thursday'];
                daysModel.thursday += total;
                daysModel.monday = days['monday'];
                daysModel.tuesday = days['tuesday'];
                daysModel.wednesday = days['wednesday'];
                daysModel.friday = days['friday'];
                daysModel.saturday = days['saturday'];
                daysModel.sunday = days['sunday'];
                daysModel.id = days['id'];
                daysModel.firstWeek = days['firstWeek'];
              } else if (getDayString(itemList[i].datetime) == "Friday") {
                total += itemList[i].amount;
                daysModel.friday = days['friday'];
                daysModel.friday += total;
                daysModel.monday = days['monday'];
                daysModel.tuesday = days['tuesday'];
                daysModel.wednesday = days['wednesday'];
                daysModel.thursday = days['thursday'];
                daysModel.saturday = days['saturday'];
                daysModel.sunday = days['sunday'];
                daysModel.id = days['id'];
                daysModel.firstWeek = days['firstWeek'];
              } else if (getDayString(itemList[i].datetime) == "Saturday") {
                total += itemList[i].amount;
                daysModel.saturday = days['saturday'];
                daysModel.saturday += total;
                daysModel.monday = days['monday'];
                daysModel.tuesday = days['tuesday'];
                daysModel.wednesday = days['wednesday'];
                daysModel.thursday = days['thursday'];
                daysModel.friday = days['friday'];
                daysModel.sunday = days['sunday'];
                daysModel.id = days['id'];
                daysModel.firstWeek = days['firstWeek'];
              } else if (getDayString(itemList[i].datetime) == "Sunday") {
                total += itemList[i].amount;
                daysModel.sunday = days['sunday'];
                daysModel.sunday += total;
                daysModel.monday = days['monday'];
                daysModel.tuesday = days['tuesday'];
                daysModel.wednesday = days['wednesday'];
                daysModel.thursday = days['thursday'];
                daysModel.friday = days['friday'];
                daysModel.saturday = days['saturday'];
                daysModel.id = days['id'];
                daysModel.firstWeek = days['firstWeek'];
              }
            }
          });
          */