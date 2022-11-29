import 'package:flutter/material.dart';
import 'package:timer_builder/timer_builder.dart';

class ClockText extends StatefulWidget {
  const ClockText({Key? key}) : super(key: key);

  @override
  State<ClockText> createState() => _ClockTextState();
}

class _ClockTextState extends State<ClockText> {
  @override
  Widget build(BuildContext context) {
    return TimerBuilder.periodic(Duration(milliseconds: 100),
        builder: (context) {
      var currentTime = DateTime.now();
      String year = currentTime.year.toString();
      String month = currentTime.month < 10
          ? "Tháng 0${currentTime.month}"
          : "Tháng ${currentTime.month}";
      String dayweek = "";
      switch (currentTime.weekday) {
        case 1:
          dayweek = "Thứ hai";
          break;
        case 2:
          dayweek = "Thứ ba";
          break;
        case 3:
          dayweek = "Thứ tư";
          break;
        case 4:
          dayweek = "Thứ năm";
          break;
        case 5:
          dayweek = "Thứ sáu";
          break;
        case 6:
          dayweek = "Thứ bảy";
          break;
        default:
          dayweek = "Chủ nhật";
      }
      String day =
          currentTime.day < 10 ? "0${currentTime.day}" : "${currentTime.day}";
      return Container(
          padding: EdgeInsets.only(left: 30),
          child: Column(
            children: [
              Text("$dayweek, $day $month năm $year",
                  style: TextStyle(height: 2.7, fontSize: 16)),
            ],
          ));
    });
  }
}
