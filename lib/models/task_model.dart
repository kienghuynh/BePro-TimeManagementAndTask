import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TaskModel {
  String? uid;
  String? title;
  String? detail;
  String? note;
  DateTime? startDate;
  DateTime? deadline;
  DateTime? doneDate;
  DateTime? createAt;
  String? colorCode;
  bool? isDone;
  bool? isImportant;

  TaskModel(
      {this.uid,
      this.title,
      this.detail,
      this.note,
      this.startDate,
      this.deadline,
      this.doneDate,
      this.createAt,
      this.colorCode,
      this.isDone,
      this.isImportant});

  // receiving data from cloud
  TaskModel fromJson(Map<String, dynamic> json) => TaskModel(
        uid: json['uid'],
        title: json['title'],
        detail: json['detail'],
        note: json['note'],
        startDate: DateFormat('dd/MM/yyyy hh:mm:ss').parse(json['startDate']),
        deadline: DateFormat('dd/MM/yyyy hh:mm:ss').parse(json['deadline']),
        doneDate: DateFormat('dd/MM/yyyy hh:mm:ss').parse(json['doneDate']),
        createAt: DateFormat('dd/MM/yyyy hh:mm:ss').parse(json['createAt']),
        colorCode: json['colorCode'],
        isDone: json['isDone'],
        isImportant: json['isImportant'],
      );

  // format date to string for post firebase
  String formatDate(DateTime? date) {
    String month = date!.month < 10 ? "0${date.month}" : "${date.month}";
    String day = date.day < 10 ? "0${date.day}" : "${date.day}";
    String hour = date.hour < 10 ? "0${date.hour}" : "${date.hour}";
    String minute = date.minute < 10 ? "0${date.minute}" : "${date.minute}";
    String second = date.second < 10 ? "0${date.second}" : "${date.second}";

    return "$day/$month/${date.year} $hour:$minute:$second";
  }

  // sending data to cloud
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'title': title,
      'detail': detail,
      'note': note,
      'startDate': (startDate==null) ? "" : formatDate(startDate),
      'deadline': (deadline==null) ? "" : formatDate(deadline),
      'doneDate': (doneDate==null) ? "" : formatDate(doneDate),
      'createAt': formatDate(createAt),
      'colorCode': colorCode,
      'isDone': isDone,
      'isImportant': isImportant,
    };
  }
}
