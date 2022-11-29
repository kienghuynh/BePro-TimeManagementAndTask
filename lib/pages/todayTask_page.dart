import 'package:bepro/models/task_model.dart';
import 'package:bepro/models/user_model.dart';
import 'package:bepro/pages/detailTask_page.dart';
import 'package:bepro/services/navigation_service.dart';
import 'package:bepro/widget/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class TodayPage extends StatefulWidget {
  const TodayPage({super.key});

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  final _formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  TaskModel modelDetail = TaskModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      //backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: const BackButton(
          color: Color.fromARGB(255, 99, 216, 204),
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Danh sách việc hôm nay',
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
          mainAxisAlignment: MainAxisAlignment.start,
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
        .snapshots(includeMetadataChanges: true);
    return Container(
      height: 630,
      margin: EdgeInsets.only(top: 15,bottom:10, left: 15, right: 15),
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
                TaskModel item = TaskModel().fromJson(data);
                // debugPrint(item.toMap().toString());

                return Container(
                    child: (compareTodayTask(
                            data['startDate'], data['deadline']))
                        ? Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 255, 255, 255),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                    color: Color.fromARGB(149, 194, 194, 194)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 5,
                                      spreadRadius: 1,
                                      offset: Offset(4, 4))
                                ]),
                            child: ListTile(
                              onTap: () {
                                NavigationService().navigateToScreen(
                                    DetailTaskPage(detailModel: item));
                              },
                              title: Row(children: [
                                Expanded(
                                  flex: 2,
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
                                          )),
                              ]),
                              subtitle: Container(
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                child: Column(children: [
                                  Utility().BottomLine(),
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
                                            color: Color.fromARGB(
                                                195, 90, 90, 90)),
                                      ),
                                    ),
                                  ]),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Utility().BottomLine(),
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
                                            style: TextStyle(
                                                color: Colors.redAccent),
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
                                            style: TextStyle(
                                                color: Colors.redAccent),
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
                                    children: [
                                      Expanded(
                                        child: Utility().BottomLine(),
                                      )
                                    ],
                                  ),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton.icon(
                                          label: Text(''),
                                          onPressed: () {
                                            doneTask(data['uid']);
                                          },
                                          icon: Icon(
                                            Icons.done_all,
                                            color: Color.fromARGB(
                                                255, 33, 242, 141),
                                            size: 30,
                                          ),
                                        ),
                                        TextButton.icon(
                                          onPressed: () {
                                            createPopUpSureDelete(data['uid']);
                                          },
                                          icon: Icon(
                                            Icons.delete_forever,
                                            color: Colors.redAccent,
                                            size: 30,
                                          ),
                                          label: Text(''),
                                        ),
                                        SizedBox(
                                          width: 22,
                                        ),
                                      ])
                                ]),
                              ),
                            ),
                          )
                        : Text(''));
              }).toList(),
            );
          }
        },
      ),
    );
  }

  bool compareTodayTask(String startDate, String deadline) {
    DateTime start = DateFormat('dd/MM/yyyy').parse(startDate);
    DateTime end = DateFormat('dd/MM/yyyy').parse(deadline);
    DateTime now = DateTime.now();
    DateTime startToday = DateTime(now.year, now.month, now.day, 0, 0, 0);

    if (start.year != startToday.year || end.year != startToday.year)
      {return false;}
    if (start.month != startToday.month || end.month != startToday.month) {
      return false;
    }
    //bat dau hom nay hoac ket thuc hom nay
    if (start.day == startToday.day || end.day == startToday.day) return true;
    //bao gom ca hom nay
    if (start.compareTo(startToday) < 0 && end.compareTo(startToday.add(Duration(hours: 23,minutes: 59,seconds: 59))) > 0) return true;
    return false;
  }

  void createPopUpSureDelete(String uid) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Container(
              width: 150,
              height: 50,
              child: Center(
                child: Text(
                  'Bạn có muốn xoá công việc này ?',
                  style: TextStyle(fontSize: 21),
                ),
              ),
            ),
            actions: [
              TextButton.icon(
                  onPressed: () {
                    DeleteTask(uid);
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

  void DeleteTask(String uid) {
    firebaseFirestore
        .collection("users")
        .doc(user!.uid)
        .collection("tasks")
        .doc(uid)
        .delete();
  }

  void doneTask(String uid) {
    DateTime doneDate = DateTime.now();
    firebaseFirestore
        .collection("users")
        .doc(user!.uid)
        .collection("tasks")
        .doc(uid)
        .set({
      'isDone': true,
      'doneDate': TaskModel().formatDate(doneDate),
      
    },SetOptions(merge: true));
  }
}
