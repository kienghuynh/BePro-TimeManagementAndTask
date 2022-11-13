import 'package:bepro/models/task_model.dart';
import 'package:bepro/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';

class AllTaskPage extends StatefulWidget {
  const AllTaskPage({super.key});

  @override
  State<AllTaskPage> createState() => _AllTaskPageState();
}

class _AllTaskPageState extends State<AllTaskPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  final _formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  TaskModel? modelDetail;

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
          'Danh sách toàn bộ',
          style: TextStyle(color: Color.fromARGB(255, 99, 216, 204)),
        ),
      ),
      body: _pageWidget(),
    ));
  }

  Widget _pageWidget() {
    return Container(
      child: SingleChildScrollView(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [list()],
        ),
      )),
    );
  }

  Widget list() {
    Stream<QuerySnapshot> _taskStream = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('tasks')
        .orderBy('createAt', descending: false)
        //.where("isImportant",isEqualTo: true)
        .snapshots(includeMetadataChanges: true);
    return Container(
      height: 630,
      margin: EdgeInsets.all(15),
      child: StreamBuilder<QuerySnapshot>(
        stream: _taskStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                // TaskModel item = TaskModel().fromJson(data);
                // debugPrint(item.toMap().toString());
                return Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(18),
                      border:
                          Border.all(color: Color.fromARGB(149, 194, 194, 194)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5,
                            spreadRadius: 1,
                            offset: Offset(4, 4))
                      ]),
                  child: ListTile(
                    onTap: () {
                      print(data['uid']);
                      getTaskById(data['uid']);
                      //print('${modelDetail!.title}');
                    },
                    title: Row(children: [
                      Expanded(
                        flex: 4,
                        child: Text(
                          data['title'],
                          style: TextStyle(fontSize: 22),
                        ),
                      ),
                      Expanded(
                          child: (data['isImportant'])
                              ? IconButton(
                                  icon: Icon(Icons.star),
                                  color: Colors.amber,
                                  onPressed: () {},
                                )
                              : IconButton(
                                  icon: Icon(Icons.star_border),
                                  color: Colors.amber,
                                  onPressed: () {},
                                ))
                    ]),
                    subtitle: Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      child: Column(children: [
                        _bordertop(),
                        SizedBox(
                          height: 15,
                        ),
                        Row(children: [
                          Expanded(
                            flex: 4,
                            child: Text(
                              data['detail'],
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Color.fromARGB(195, 90, 90, 90)),
                            ),
                          ),
                        ]),
                        SizedBox(
                          height: 15,
                        ),
                        _bordertop(),
                        SizedBox(
                          height: 10,
                        ),
                        Row(children: [
                          Column(
                            children: [
                              Center(child: Icon(Icons.edit_calendar))
                            ],
                          ),
                          Column(children: [
                            Row(
                              children: [
                                Text(
                                  '  Từ: ${data['startDate']}',
                                  style: TextStyle(color: Colors.redAccent),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                  '   Tới: ${data['deadline']}',
                                  style: TextStyle(color: Colors.redAccent),
                                ),
                              ],
                            ),
                          ]),
                        ]),
                        Row(
                          children: [
                            SizedBox(
                              height: 15,
                            )
                          ],
                        ),
                        Row(
                          children: [Expanded(child: _bordertop())],
                        )
                      ]),
                    ),
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }

  Widget _bordertop() {
    return Container(
      height: 1,
      margin: EdgeInsets.only(right: 35),
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          border: Border(
              top: BorderSide(color: Color.fromARGB(90, 0, 0, 0), width: 1))),
    );
  }

  Future<void> getTaskById(String uid) async {
    var snapshot = await firebaseFirestore
        .collection("users")
        .doc(user!.uid)
        .collection("tasks")
        .get();
    List<TaskModel> list =
        snapshot.docs.map((e) => TaskModel().fromJson(e.data())).toList();

    for (var item in list) {
      if (item.uid == uid)
        setState(() {
          modelDetail = item;
        });
    }
  }
}
