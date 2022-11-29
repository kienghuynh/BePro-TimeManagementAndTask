import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CategoryModel {
  String? uid;
  String? categoryName;
 

  CategoryModel(
      {this.uid, this.categoryName});

  // receiving data from cloud
  CategoryModel fromJson(Map<String, dynamic> json) => CategoryModel(
        uid: json['uid'],
        categoryName: json['categoryName'],
        
      );

  // sending data to cloud
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'categoryName': categoryName
    };
  }
}
