import 'package:bepro/models/Category_model.dart';
import 'package:bepro/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DropdownPreperation extends StatefulWidget {
  DropdownPreperation({Key? key}) : super(key: key);

  @override
  _DropdownPreperation createState() => _DropdownPreperation();
}

class _DropdownPreperation extends State<DropdownPreperation> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  final _formKey = GlobalKey<FormState>();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  List<String> items = [];

  String? selectedValue;

  List<DropdownMenuItem<String>> _addDividersAfterItems( items) {
    List<DropdownMenuItem<String>> _menuItems = [];
    for (var item in items) {
      _menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1.0),
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
          //If it's last item, we will not add Divider after it.
          if (item != items.last)
            const DropdownMenuItem<String>(
              enabled: false,
              child: Divider(height: 10,),
            ),
        ],
      );
    }
    return _menuItems;
  }

  // List<int> _getDividersIndexes() {
  //   List<int> _dividersIndexes = [];
  //   for (var i = 0; i < (items.length * 2) - 1; i++) {
  //     //Dividers indexes will be the odd indexes
  //     if (i.isOdd) {
  //       _dividersIndexes.add(i);
  //     }
  //   }
  //   return _dividersIndexes;
  // }

  @override
  void initState() {
    getCategories();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: Colors.blueGrey, width: 1, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(5)),
        padding: EdgeInsets.all(5),
        child: DropdownButtonHideUnderline(
            child: DropdownButton(
                hint: Text(
                  'Loại công việc',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                items: _addDividersAfterItems(items),
                value: selectedValue,
                onChanged: (value) {
                  setState(() {
                    selectedValue = value as String;
                  });
                })));
  }

  Future<void> getCategories() async {
    var snapshotValue = await firebaseFirestore
        .collection("users")
        .doc(user!.uid)
        .collection("categories")
        .get();

    List<CategoryModel> list = snapshotValue.docs
        .map((e) => CategoryModel().fromJson(e.data()))
        .toList();

    setState(() {
      for (var item in list) {
        items.add(item.categoryName!);
      }
    });
  }
}
