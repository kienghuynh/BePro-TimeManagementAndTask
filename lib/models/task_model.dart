import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TaskModel {
  String? uid;
  String? title;
  String? detail;
  String? note;
  DateTime? startDate;
  DateTime? deadline;
  DateTime? endDate;
  bool? isDone;
  bool? isImportant;

  TaskModel(
      {this.uid,
      this.title,
      this.detail,
      this.note,
      this.startDate,
      this.deadline,
      this.endDate,
      this.isDone,
      this.isImportant});

  // receiving data from cloud
  TaskModel fromJson(Map<String, dynamic> json) => TaskModel(
    uid: json['uid'],
    title: json['title'],
    detail: json['detail'],
    note: json['note'],
    startDate: DateFormat('MM/dd/yy').parse(json['startDate']),
    deadline:DateFormat('MM/dd/yy').parse(json['deadline']),
    endDate:DateFormat('MM/dd/yy').parse(json['endDate']),
    isDone: json['isDone'],
    isImportant: json['isImportant'],

  );

  // sending data to cloud
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'title': title,
      'detail': detail,
      'note': note,
      'startDate': startDate,
      'deadline': deadline,
      'endDate': endDate,
      'isDone': isDone,
      'isImportant': isImportant,
    };
  }
}
