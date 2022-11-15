import 'package:bepro/pages/task_page.dart.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  Widget TextFieldEdit(
       double fontSize, FontWeight fontWeight, TextEditingController controller, Icon icon, Color colorText) {
    var border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.transparent));

    return TextFormField(
      
      expands: true,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      style: TextStyle(color: colorText, fontSize: fontSize, fontWeight: fontWeight),
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
              fontSize: fontSize, fontWeight: fontWeight, color: colorText, fontStyle: FontStyle.italic),
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

  String formatDateDisplay(DateTime? date) {
    String month = date!.month < 10 ? "0${date.month}" : "${date.month}";
    String day = date.day < 10 ? "0${date.day}" : "${date.day}";
    String hour = date.hour < 10 ? "0${date.hour}" : "${date.hour}";
    String minute = date.minute < 10 ? "0${date.minute}" : "${date.minute}";
    String second = date.second < 10 ? "0${date.second}" : "${date.second}";

    return "$hour:$minute ngày $day/$month/${date.year}";
  }
}
