import 'package:bepro/pages/task_page.dart.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';

class Utility {
  Widget BottomLine() {
    return Container(
      height: 1,
      margin: EdgeInsets.only(left: 5, right: 35),
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          border: Border(
              top: BorderSide(color: Color.fromARGB(90, 0, 0, 0), width: 1))),
    );
  }

  Widget TextFieldCustom(
      String hintText, TextEditingController controller, Icon icon) {
    var border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.black));

    return TextFormField(
      expands: true,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      style: const TextStyle(color: Colors.black, fontSize: 18),
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: icon,
        hintText: hintText,
        hintStyle: const TextStyle(color: Color.fromARGB(86, 0, 0, 0)),
        enabledBorder: border,
        focusedBorder: border,
        filled: true,
        fillColor: const Color.fromARGB(79, 236, 249, 247),
      ),
    );
  }

  Widget TextFieldEdit(double fontSize, FontWeight fontWeight,
      TextEditingController controller, Icon icon, Color colorText) {
    var border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.transparent));

    return TextFormField(
      expands: true,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      style: TextStyle(
          color: colorText, fontSize: fontSize, fontWeight: fontWeight),
      controller: controller,
      decoration: InputDecoration(
        border: InputBorder.none,
        prefixIcon: icon,
        hintStyle: const TextStyle(color: Color.fromARGB(86, 0, 0, 0)),
        enabledBorder: border,
        focusedBorder: border,
        filled: true,
        fillColor: Colors.transparent,
      ),
    );
  }

  Widget TextFieldCustomReadOnly(String hintText, Icon icon) {
    var border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.black));

    return TextFormField(
      expands: true,
      maxLines: null,
      enabled: false,
      keyboardType: TextInputType.multiline,
      style: const TextStyle(color: Colors.black, fontSize: 18),

      //controller: controller,
      decoration: InputDecoration(
        prefixIcon: icon,
        hintText: hintText,
        hintStyle: const TextStyle(color: Color.fromARGB(86, 0, 0, 0)),
        enabledBorder: border,
        focusedBorder: border,
        filled: true,
        fillColor: const Color.fromARGB(79, 236, 249, 247),
      ),
    );
  }

  Widget DisplayTextDetail(IconData icon, String text, double fontSize,
      FontWeight fontWeight, Color colorText) {
    return Row(children: [
      Expanded(
          child: Icon(
        icon,
        color: colorText,
        size: fontSize + 6,
      )),
      Expanded(
        flex: 4,
        child: Text(
          text,
          style: TextStyle(
              fontSize: fontSize, fontWeight: fontWeight, color: colorText),
        ),
      ),
    ]);
  }

  Widget DisplayNotiNull(IconData icon, String text, double fontSize,
      FontWeight fontWeight, Color colorText) {
    return Row(children: [
      Expanded(
          child: Icon(
        icon,
        color: colorText,
        size: fontSize + 6,
      )),
      Expanded(
        flex: 4,
        child: Text(
          text,
          style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: colorText,
              fontStyle: FontStyle.italic),
        ),
      ),
    ]);
  }

  Widget DisplayImportant(IconData icon, String text, double fontSize,
      FontWeight fontWeight, Color colorIcon) {
    return Row(children: [
      Expanded(
          child: Icon(
        icon,
        color: colorIcon,
        size: fontSize + 12,
      )),
      Expanded(
        flex: 4,
        child: Text(
          text,
          style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: Color.fromARGB(255, 70, 70, 70)),
        ),
      ),
    ]);
  }

  Widget DisplayDateTime(DateTime date) {
    return Center(
        child: Text(
      "${date.hour}:${date.minute} ${date.day}/${date.month}/${date.year}",
      style: TextStyle(
          fontSize: 18, color: Colors.blue, fontWeight: FontWeight.w500),
    ));
  }

  Widget DisplayDate(DateTime date) {
    return Center(
        child: Text(
      "${date.day}/${date.month}/${date.year}",
      style: TextStyle(
          fontSize: 18, color: Colors.blue, fontWeight: FontWeight.w500),
    ));
  }

  String formatDateDisplay(DateTime? date) {
    String month = date!.month < 10 ? "0${date.month}" : "${date.month}";
    String day = date.day < 10 ? "0${date.day}" : "${date.day}";
    String hour = date.hour < 10 ? "0${date.hour}" : "${date.hour}";
    String minute = date.minute < 10 ? "0${date.minute}" : "${date.minute}";
    String second = date.second < 10 ? "0${date.second}" : "${date.second}";

    return "$hour:$minute ngày $day/$month/${date.year}";
  }

  bool compareToday(String startDate, String deadline) {
    DateTime start = DateFormat('yyyy-MM-dd hh:mm:ss').parse(startDate);
    DateTime end = DateFormat('yyyy-MM-dd hh:mm:ss').parse(deadline);
    DateTime now = DateTime.now();
    DateTime startToday = DateTime(now.year, now.month, now.day, 0, 0, 0);
    print(startToday);

    if (start.year != startToday.year || end.year != startToday.year) {
      return false;
    }
    if (start.month != startToday.month || end.month != startToday.month) {
      return false;
    }
    //bat dau hom nay hoac ket thuc hom nay
    if (start.day == startToday.day || end.day == startToday.day) return true;
    //bao gom ca hom nay
    if (start.compareTo(startToday) < 0 &&
        end.compareTo(
                startToday.add(Duration(hours: 23, minutes: 59, seconds: 59))) >
            0) return true;
    return false;
  }

  bool compareRangeTime(
      String startDate, String deadline, String iStartRange, String iEndRange) {
    DateTime start = DateFormat('dd/MM/yyyy hh:mm:ss').parse(startDate);
    DateTime end = DateFormat('dd/MM/yyyy hh:mm:ss').parse(deadline);
    DateTime startRange = DateFormat('yyyy-MM-dd hh:mm:ss').parse(iStartRange);
    DateTime endRange = DateFormat('yyyy-MM-dd hh:mm:ss').parse(iEndRange);
    DateTime startRange_withoutTime =
        DateTime(startRange.year, startRange.month, startRange.day, 0, 0, 0);
    DateTime endRange_fullday =
        DateTime(endRange.year, endRange.month, endRange.day, 23, 59, 59);

    

    if (start.compareTo(startRange_withoutTime) < 0 &&
        end.compareTo(endRange_fullday) > 0) {
      return true;
    }
    if (start.compareTo(startRange_withoutTime) < 0 &&
        end.compareTo(startRange_withoutTime) > 0) {
      return true;
    }
    if (start.compareTo(endRange_fullday) < 0 &&
        end.compareTo(endRange_fullday) > 0) {
      return true;
    }
    if (start.compareTo(startRange_withoutTime) > 0 &&
        end.compareTo(endRange_fullday) < 0) {
      return true;
    }
    return false;
  }
  
  bool compareRangeTimeDate(
      DateTime startDate, DateTime deadline, DateTime iStartRange, DateTime iEndRange) {
    
    DateTime startRange_withoutTime =
        DateTime(iStartRange.year, iStartRange.month, iStartRange.day, 0, 0, 0);
    DateTime endRange_fullday =
        DateTime(iEndRange.year, iEndRange.month, iEndRange.day, 23, 59, 59);
   

    if (startDate.compareTo(startRange_withoutTime) < 0 &&
        deadline.compareTo(endRange_fullday) > 0) {
      return true;
    }
    if (startDate.compareTo(startRange_withoutTime) < 0 &&
        deadline.compareTo(startRange_withoutTime) > 0) {
      return true;
    }
    if (startDate.compareTo(endRange_fullday) < 0 &&
        deadline.compareTo(endRange_fullday) > 0) {
      return true;
    }
    if (startDate.compareTo(startRange_withoutTime) > 0 &&
        deadline.compareTo(endRange_fullday) < 0) {
      return true;
    }
    return false;
  }

  Widget ImageWidget(String url, double height) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          alignment: Alignment(0, -0.8),
          image: AssetImage('$url'),
        ),
      ),
      height: height,
    );
  }
}
