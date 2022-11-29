import 'dart:math';

import 'package:bepro/models/Category_model.dart';
import 'package:bepro/models/task_model.dart';
import 'package:bepro/models/user_model.dart';
import 'package:bepro/services/navigation_service.dart';
import 'package:bepro/widget/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  final _formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  TextEditingController categoryController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
        // decoration: const BoxDecoration(
        //   gradient: LinearGradient(colors: [
        //     Color.fromARGB(255, 221, 181, 73),
        //     Color.fromARGB(255, 99, 216, 204)
        //   ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        // ),
        child: Scaffold(
      //backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: const BackButton(
          color: Color.fromARGB(255, 99, 216, 204),
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Danh sách nhóm công việc',
          style: TextStyle(color: Color.fromARGB(255, 99, 216, 204)),
        ),
        actions: [
          TextButton.icon(
              //onPressed: () {},
              onPressed: showDialogCreateCategory,
              icon: Icon(
                Icons.add_outlined,
                size: 34,
                color: Color.fromARGB(255, 99, 216, 204),
              ),
              label: Text(''))
        ],
      ),
      body: _pageWidget(),
    ));
  }

  Widget _pageWidget() {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(child: list()),
          ],
        ),
      )),
    );
  }

  Widget list() {
    Stream<QuerySnapshot> _taskStream = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('categories')
        .snapshots(includeMetadataChanges: true);
    return Column(
      children: [
        Container(
          height: 350,
          margin: EdgeInsets.all(15),
          child: StreamBuilder<QuerySnapshot>(
            stream: _taskStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Something went wrong'));
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    CategoryModel item = CategoryModel().fromJson(data);
                    // debugPrint(item.toMap().toString());

                    return Container(
                        child: Container(
                      child: ListTile(
                        onTap: () {},
                        title: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    flex: 4,
                                    child: _textDisplay(item.categoryName!)),
                                Expanded(
                                    child: IconButton(
                                        onPressed: () {
                                          createPopUpSureDelete(
                                              item.uid!, item.categoryName!);
                                        },
                                        icon: Icon(
                                          Icons.delete_rounded,
                                          color: Colors.redAccent,
                                        ))),
                                // Expanded(
                                //     child: IconButton(
                                //         onPressed: () {
                                //         },
                                //         icon: Icon(
                                //           Icons.edit,
                                //           color: Colors.blueAccent,
                                //         )))
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                            Utility().BottomLine(),
                          ],
                        ),
                      ),
                    ));
                  }).toList(),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _textDisplay(String text) {
    return Container(
      child: Text(
        text,
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  void showDialogCreateCategory() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            'Tạo mới nhóm công việc',
            style: TextStyle(color: Colors.blue),
          ),
          content: Container(
            height: 100,
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                        width: 250,
                        height: 100,
                        alignment: Alignment.centerLeft,
                        child: Utility().TextFieldCustom('Tên nhóm',
                            categoryController, Icon(Icons.abc_outlined))),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton.icon(
              icon: Icon(
                Icons.done_all,
                color: Color.fromARGB(255, 0, 177, 6),
                size: 30,
              ),
              onPressed: () {
                postCategoryToFireStore();
              },
              label: Text(
                '',
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 177, 6), fontSize: 18),
              ),
            ),
          ],
        );
      },
    );
  }

  void createPopUpSureDelete(String uid, String category) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Container(
              width: 150,
              height: 50,
              child: Center(
                child: Text(
                  'Bạn có muốn xoá nhóm công việc này ?',
                  style: TextStyle(fontSize: 21),
                ),
              ),
            ),
            actions: [
              TextButton.icon(
                  onPressed: () {
                    DeleteTask(uid, category);
                    NavigationService().goBack();
                  },
                  icon: Icon(
                    Icons.delete_forever,
                    color: Colors.redAccent,
                    size: 30,
                  ),
                  label: Text('Xoá',
                      style: TextStyle(fontSize: 21, color: Colors.redAccent))),
              TextButton.icon(
                  onPressed: () {
                    NavigationService().goBack();
                  },
                  icon: Icon(
                    Icons.clear_outlined,
                    color: Colors.grey,
                    size: 30,
                  ),
                  label: Text(
                    'Không',
                    style: TextStyle(fontSize: 21, color: Colors.grey),
                  ))
            ],
          );
        });
  }

  Future<void> DeleteTask(String uid, String category) async {
    Future<bool> check = checkCategoryEmpty(category);
    if (await check) {
      firebaseFirestore
          .collection("users")
          .doc(user!.uid)
          .collection("categories")
          .doc(uid)
          .delete();
    } else {
      Fluttertoast.showToast(msg: 'Vẫn còn công việc trong nhóm công việc này');
    }
  }

  Future<bool> checkCategoryEmpty(String category) async {
    var snapshotTasks = await firebaseFirestore
        .collection("users")
        .doc(user!.uid)
        .collection("tasks")
        .get();

    List<TaskModel> list =
        snapshotTasks.docs.map((e) => TaskModel().fromJson(e.data())).toList();

    for (var item in list) {
      if (item.category == category) {
        return false;
      }
    }
    return true;
  }

  postCategoryToFireStore() async {
    var uuid = Uuid().v4();
    Random random = Random();
    CategoryModel item = CategoryModel();

    item.categoryName = categoryController.text.trim();
    item.uid = uuid;

    if (categoryController.text != null) {
      await firebaseFirestore
          .collection("users")
          .doc(user!.uid)
          .collection("categories")
          .doc(item.uid)
          .set(item.toMap());
      Fluttertoast.showToast(msg: "Đã thêm 1 loại công việc");
      NavigationService().goBack();
      setState(() {});
    } else {
      Fluttertoast.showToast(msg: 'Tên loại công việc không trống');
    }
  }
}
