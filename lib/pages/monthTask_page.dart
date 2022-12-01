import 'package:bepro/Utility/CustomPickerMonth.dart';
import 'package:bepro/models/task_model.dart';
import 'package:bepro/models/user_model.dart';
import 'package:bepro/pages/detailTask_page.dart';
import 'package:bepro/services/navigation_service.dart';
import 'package:bepro/Utility/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class MonthTaskPage extends StatefulWidget {
  const MonthTaskPage({super.key});

  @override
  State<MonthTaskPage> createState() => _MonthTaskPageState();
}

class _MonthTaskPageState extends State<MonthTaskPage> {
  DateTime? selectedMonth;
  final User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  final _formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  TaskModel modelDetail = TaskModel();

  DateTime? startDate;
  DateTime? deadline;

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
          'Danh sách công việc ',
          style: TextStyle(color: Color.fromARGB(255, 99, 216, 204)),
        ),
        actions: [
          TextButton.icon(
              onPressed: () {
                showPickerMonth();
              },
              icon: Icon(
                Icons.calendar_month_outlined,
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
      child: SingleChildScrollView(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            children: [
              disPlayCurrentTime(),
              (startDate == null || deadline == null)
                  ? list(DateTime(DateTime.now().year,DateTime.now().month,1,0,0,0),
                      DateTime(DateTime.now().year,DateTime.now().month+1,0,0,0,0))
                  : list(startDate!, deadline!)
            ],
          )),
    );
  }

  Widget disPlayCurrentTime(){
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(10),
          border: Border.all(
          color: Color.fromARGB(149, 194, 194, 194)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5,
              spreadRadius: 1,
              offset: Offset(4, 4))
      ]),
      child: (startDate == null || deadline == null) 
        ? Text('Danh sách công việc cho tháng ${DateTime.now().month}', style: TextStyle( fontSize: 18),)
        : Text('Danh sách công việc cho tháng ${startDate!.month}', style: TextStyle( fontSize: 18),)
    );
  }

  Widget list(DateTime startDate, DateTime deadline) {
    Stream<QuerySnapshot> _taskStream = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('tasks')
        .orderBy('createAt', descending: true)
        //.where("isImportant",isEqualTo: true)
        .snapshots(includeMetadataChanges: true);
    return Container(
      height: 630,
      margin: EdgeInsets.only(bottom:10, left: 15, right: 15),
      child: StreamBuilder<QuerySnapshot>(
        stream: _taskStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (startDate == null || deadline == null) {
            return Center(
              child: Text(''),
            );
          } else {
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                TaskModel item = TaskModel().fromJson(data);
                // debugPrint(item.toMap().toString());
                return Container(
                    child: (Utility().compareRangeTime(
                            data['startDate'],
                            data['deadline'],
                            startDate.toString(),
                            deadline.toString()))
                        ? Container(
                            margin: EdgeInsets.only(bottom: 10,left: 10, right: 10),
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
                                            createPopUpDone(data['uid']);
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

  void createPopUpDone(String uid) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Container(
              width: 150,
              height: 50,
              child: Center(
                child: Text(
                  'Bạn đã hoàn thành công việc này ?',
                  style: TextStyle(fontSize: 21),
                ),
              ),
            ),
            actions: [
              TextButton.icon(
                  onPressed: () {
                    doneTask(uid);
                    NavigationService().goBack();
                  },
                  icon: Icon(
                    Icons.done_all,
                    color: Color.fromARGB(255, 113, 231, 111),
                    size: 30,
                  ),
                  label: Text('Hoàn thành',
                      style: TextStyle(
                          fontSize: 21,
                          color: Color.fromARGB(255, 113, 231, 111)))),
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

  Widget TimePickerStartDate() {
    return TextButton.icon(
      onPressed: () {
        setState(() {
          DatePicker.showDatePicker(context,
              showTitleActions: true,
              minTime: DateTime(2000, 1, 1),
              maxTime: DateTime(2099, 12, 31),
              onChanged: (date) {}, onConfirm: (date) {
            startDate = date;
            NavigationService().goBack();
            showDialogPickRange();
            setState(() {});
          },
              currentTime: (startDate == null) ? DateTime.now() : startDate,
              locale: LocaleType.vi);
        });
      },
      label: Text(
        'Từ',
        style: TextStyle(color: Colors.blue, fontSize: 18),
      ),
      icon: Icon(Icons.access_time),
    );
  }

  Widget TimePickerDeadline() {
    return TextButton.icon(
      onPressed: () {
        setState(() {
          DatePicker.showDatePicker(context,
              showTitleActions: true,
              minTime: startDate?.add(Duration(days: 1)),
              maxTime: DateTime(2099, 12, 31),
              onChanged: (date) {}, onConfirm: (date) {
            deadline = date;
            NavigationService().goBack();
            showDialogPickRange();
            setState(() {});
          },
              currentTime: (deadline == null) ? startDate : deadline,
              locale: LocaleType.vi);
        });
      },
      label: Text(
        'Đến',
        style: TextStyle(color: Colors.blue, fontSize: 18),
      ),
      icon: Icon(Icons.access_time),
    );
  }

  void showDialogPickRange() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            'Chọn thời gian',
            style: TextStyle(color: Colors.blue),
          ),
          content: Container(
            height: 100,
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 50,
                      width: 200,
                      alignment: Alignment.centerLeft,
                      child: Row(children: [
                        TimePickerStartDate(),
                        (startDate != null)
                            ? Utility().DisplayDate(startDate!)
                            : Text('')
                      ]),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      height: 50,
                      width: 200,
                      alignment: Alignment.centerLeft,
                      child: Row(children: [
                        TimePickerDeadline(),
                        (deadline != null)
                            ? Utility().DisplayDate(deadline!)
                            : Text('')
                      ]),
                    ),
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
                NavigationService().goBack();
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
    }, SetOptions(merge: true));
  }

  void showPickerMonth() {
    DatePicker.showPicker(context,
        pickerModel: CustomMonthPicker(
            minTime: DateTime(2000),
            maxTime: DateTime(2099),
            currentTime: DateTime.now()),
        onChanged: (month) {}, onConfirm: (month) {
      setState(() {
        startDate = DateTime(month.year, month.month, 1);
        deadline = DateTime(month.year, month.month + 1, 0);
      });
    }, locale: LocaleType.vi);
  }
}


