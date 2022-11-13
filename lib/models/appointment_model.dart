import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AppointmentModel {
  String? uid;
  String? title;
  DateTime? startDate;
  DateTime? deadline;
  int? colorCode;


  AppointmentModel(
      {this.uid,
      this.title,
      this.startDate,
      this.deadline,
      this.colorCode
      });

  // receiving data from cloud
  AppointmentModel fromJson(Map<String, dynamic> json) => AppointmentModel(
        uid: json['uid'],
        title: json['title'],
        startDate: DateFormat('dd/MM/yyyy hh:mm:ss').parse(json['startDate']),
        deadline: DateFormat('dd/MM/yyyy hh:mm:ss').parse(json['deadline']),
        colorCode:int.parse(json['colorCode'] ) ,
      );

  // sending data to cloud
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'title': title,
      'startDate': startDate,
      'deadline': deadline,
      'colorCode':colorCode
    };
  }
}
