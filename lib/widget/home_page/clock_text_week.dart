import 'package:flutter/material.dart';
import 'package:timer_builder/timer_builder.dart';

class ClockTextWeek extends StatefulWidget {
  const ClockTextWeek({Key? key}) : super(key: key);

  @override
  State<ClockTextWeek> createState() => _ClockTextWeekState();
}

class _ClockTextWeekState extends State<ClockTextWeek> {
  @override
  Widget build(BuildContext context) {
    return TimerBuilder.periodic(Duration(milliseconds: 100),
        builder: (context) {
      var currentTime = DateTime.now();
      String day;
      int bonusDay;
      switch (currentTime.weekday) {
        case 1:
          day = "Thứ hai";
          bonusDay = 0;
          break;
        case 2:
          day = "Thứ ba";
          bonusDay = -1;
          break;
        case 3:
          day = "Thứ tư";
          bonusDay = -2;
          break;
        case 4:
          day = "Thứ năm";
          bonusDay = -3;
          break;
        case 5:
          day = "Thứ sáu";
          bonusDay = -4;
          break;
        case 6:
          day = "Thứ bảy";
          bonusDay = -5;
          break;
        default:
          bonusDay = -6;
          day = "Chủ nhật";
      }
      var nextWeekFromNow = currentTime.add(Duration(days: bonusDay));
      var sevenDayFromNextWeek = nextWeekFromNow.add(Duration(days: 6));
      String nextWeek_dayDisplay = nextWeekFromNow.day < 10
          ? "0${nextWeekFromNow.day}"
          : "${nextWeekFromNow.day}";
      String nextWeek_monthDisplay = nextWeekFromNow.month < 10
          ? "Tháng 0${nextWeekFromNow.month}"
          : "Tháng ${nextWeekFromNow.month}";
      String seven_dayDisplay = sevenDayFromNextWeek.day < 10
          ? "0${sevenDayFromNextWeek.day}"
          : "${sevenDayFromNextWeek.day}";
      String sevenday_monthDisplay = sevenDayFromNextWeek.month < 10
          ? "Tháng 0${sevenDayFromNextWeek.month}"
          : "Tháng ${sevenDayFromNextWeek.month}";
      return Container(
          padding: EdgeInsets.only(left: 30),
          child: Column(
            children: [
              Text(
                  "${nextWeek_dayDisplay} ${nextWeek_monthDisplay} - ${seven_dayDisplay} ${sevenday_monthDisplay} năm ${sevenDayFromNextWeek.year}",
                  style: TextStyle(height: 2.7, fontSize: 16)),
            ],
          ));
    });
  }
}
