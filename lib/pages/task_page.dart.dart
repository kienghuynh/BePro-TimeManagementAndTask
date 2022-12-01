import 'dart:math';

import 'package:bepro/models/category_model.dart';
import 'package:bepro/models/task_model.dart';
import 'package:bepro/models/user_model.dart';
import 'package:bepro/pages/calendar_page.dart';
import 'package:bepro/pages/category_page.dart';
import 'package:bepro/pages/currentWeekTask_page.dart';
import 'package:bepro/pages/doneTask_page.dart';
import 'package:bepro/pages/importantTask_page.dart';
import 'package:bepro/pages/login_page.dart';
import 'package:bepro/pages/monthTask_page.dart';
import 'package:bepro/pages/todayTask_page.dart';
import 'package:bepro/services/navigation_service.dart';
import 'package:bepro/widget/home_page/clock_text.dart';
import 'package:bepro/widget/home_page/clock_text_week.dart';
import 'package:bepro/widget/home_page/dropDown_Categories.dart';
import 'package:bepro/Utility/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:uuid/uuid.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  final _formKey = GlobalKey<FormState>();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  TextEditingController titleController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  String countAllTask = '';
  String countTodayTask = '';
  String countImportantTask = '';
  String countDoneTask = '';
  String countWeekTask = '';

  bool isImportant = false;

  DateTime? startDate;
  DateTime? deadline;

  List<String> items = [];

  String? selectedValue;

  @override
  void initState() {
    super.initState();
    countall();
    getCategories();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: Color.fromARGB(255, 99, 216, 204)),
          backgroundColor: Colors.white,
          title: Center(
            child: const Text(
              'Quản lý thời gian & công việc',
              style: TextStyle(color: Color.fromARGB(255, 99, 216, 204)),
            ),
          ),
        ),
        body: _pageWidget(),
        extendBody: true,
        floatingActionButton: _btnAddFloating(),
      ),
    );
  }

  Widget _pageWidget() {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        child: _introText(),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        child: _introTextAmount(),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                          width: 350,
                          child: Utility()
                              .ImageWidget('assets/background-login.png', 220)),
                      //Container(child: Text('data'),width: 100,color: Color.fromARGB(255, 31, 229, 24) ),
                    ],
                  ),
                  Row(
                    children: [_allTaskButton()],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [_todayButton(), _weekButton()],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [_importantButton(), _completedButton()],
                  ),
                  SizedBox(
                    height: 45,
                  ),
                  Row(
                    children: [_categoryButton()],
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget _introText() {
    return Container(
        margin: EdgeInsets.only(top: 25, left: 25),
        child: Row(
          children: [
            Icon(
              Icons.waving_hand_outlined,
              color: Color.fromARGB(255, 81, 177, 168),
              size: 40,
            ),
            Text(
              '  Hi ${loggedInUser.fullName} ',
              style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  color: Color.fromARGB(255, 81, 177, 168)),
            )
          ],
        ));
  }

  Widget _introTextAmount() {
    return Container(
        child: Row(
      children: [
        Text(
          (countTodayTask != 0)
              ? '                   Hôm nay bạn có $countTodayTask việc !'
              : '                   Hôm nay bạn không có việc !',
          style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: Color.fromARGB(255, 88, 88, 88)),
        )
      ],
    ));
  }

  Widget _weekButton() {
    return Container(
      height: 100,
      margin: EdgeInsets.only(left: 10),
      width: 170,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromARGB(255, 200, 247, 242),
            Color.fromARGB(255, 255, 255, 255),
            Color.fromARGB(255, 255, 255, 255),
            Color.fromARGB(255, 255, 255, 255),
            Color.fromARGB(255, 255, 255, 255),
            Color.fromARGB(255, 255, 255, 255),
            Color.fromARGB(255, 255, 255, 255),
            Color.fromARGB(255, 255, 255, 255),
          ], begin: Alignment.centerRight, end: Alignment.centerLeft),
          //color: Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Color.fromARGB(149, 194, 194, 194)),
          boxShadow: [
            BoxShadow(
                color: Color.fromARGB(255, 81, 177, 168),
                blurRadius: 1,
                //spreadRadius: 1,
                offset: Offset(1, 1))
          ]),
      child: OutlinedButton(
          style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.transparent)),
          onPressed: () {
            NavigationService().navigateToScreen(CurrentWeekPage());
          },
          child: Stack(
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.assignment_rounded,
                    color: Color.fromARGB(255, 255, 88, 10),
                    size: 30,
                  )),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "        Tuần này \n              ($countWeekTask)",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      height: 1.4,
                      fontSize: 15,
                      color: Color.fromARGB(255, 99, 99, 99),
                    ),
                  ))
            ],
          )),
    );
  }

  Widget _allTaskButton() {
    return Container(
      height: 100,
      margin: EdgeInsets.only(left: 10),
      width: 350,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromARGB(255, 200, 247, 242),
            Color.fromARGB(255, 255, 255, 255),
            Color.fromARGB(255, 255, 255, 255),
            Color.fromARGB(255, 255, 255, 255),
            Color.fromARGB(255, 255, 255, 255),
            Color.fromARGB(255, 255, 255, 255),
            Color.fromARGB(255, 255, 255, 255),
            Color.fromARGB(255, 255, 255, 255),
          ], begin: Alignment.centerRight, end: Alignment.centerLeft),
          //color: Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Color.fromARGB(149, 194, 194, 194)),
          boxShadow: [
            BoxShadow(
                color: Color.fromARGB(255, 81, 177, 168),
                blurRadius: 1,
                offset: Offset(1, 1))
          ]),
      child: OutlinedButton(
          style: OutlinedButton.styleFrom(
              side: BorderSide(color: Color.fromARGB(0, 44, 44, 44))),
          onPressed: () {
            NavigationService().navigateToScreen(MonthTaskPage());
          },
          child: Stack(
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.article_outlined,
                    color: Color.fromARGB(255, 84, 155, 255),
                    size: 30,
                  )),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "        Danh sách tháng",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      height: 1.4,
                      fontSize: 15,
                      color: Color.fromARGB(255, 75, 75, 75),
                    ),
                  ))
            ],
          )),
    );
  }

  Widget _todayButton() {
    return Container(
      height: 100,
      margin: EdgeInsets.only(left: 10),
      width: 170,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 200, 247, 242),
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255),
            ],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
          //color: Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Color.fromARGB(149, 194, 194, 194)),
          boxShadow: [
            BoxShadow(
                color: Color.fromARGB(255, 81, 177, 168),
                blurRadius: 1,
                //spreadRadius: 1,
                offset: Offset(1, 1))
          ]),
      child: OutlinedButton(
          style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.transparent)),
          onPressed: () {
            NavigationService().navigateToScreen(TodayPage());
          },
          child: Stack(
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.article_outlined,
                    color: Color.fromARGB(255, 255, 12, 57),
                    size: 30,
                  )),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "        Hôm nay\n              ($countTodayTask)    ",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      height: 1.4,
                      fontSize: 15,
                      color: Color.fromARGB(255, 75, 75, 75),
                    ),
                  ))
            ],
          )),
    );
  }

  Widget _importantButton() {
    return Container(
      height: 100,
      width: 170,
      margin: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 244, 248, 167),
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255),
            ],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
          //color: Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Color.fromARGB(255, 231, 215, 139)),
          boxShadow: [
            BoxShadow(
                color: Color.fromARGB(255, 224, 210, 139),
                blurRadius: 1,
                //spreadRadius: 1,
                offset: Offset(1, 1))
          ]),
      child: OutlinedButton(
          style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.transparent)),
          onPressed: () {
            NavigationService().navigateToScreen(ImportantPage());
          },
          child: Stack(
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.grade,
                    color: Color.fromARGB(255, 255, 218, 35),
                    size: 30,
                  )),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "        Việc quan \n            trọng",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      height: 1.5,
                      fontSize: 15,
                      color: Color.fromARGB(255, 75, 75, 75),
                    ),
                  ))
            ],
          )),
    );
  }

  Widget _completedButton() {
    return Container(
      height: 100,
      width: 170,
      margin: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 190, 248, 167),
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255),
            ],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
          //color: Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Color.fromARGB(255, 166, 228, 137)),
          boxShadow: [
            BoxShadow(
                color: Color.fromARGB(255, 152, 218, 136),
                blurRadius: 1,
                //spreadRadius: 1,
                offset: Offset(1, 1))
          ]),
      child: OutlinedButton(
          style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.transparent)),
          onPressed: () {
            NavigationService().navigateToScreen(DonePage());
          },
          child: Stack(
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.done_all_outlined,
                    color: Color.fromARGB(255, 67, 227, 123),
                    size: 30,
                  )),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "            Việc đã \n         hoàn thành",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      height: 1.5,
                      fontSize: 15,
                      color: Color.fromARGB(255, 75, 75, 75),
                    ),
                  ))
            ],
          )),
    );
  }

  Widget _categoryButton() {
    return Container(
      height: 100,
      width: 350,
      margin: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 167, 248, 248),
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255),
            ],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
          //color: Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Color.fromARGB(255, 130, 218, 215)),
          boxShadow: [
            BoxShadow(
                color: Color.fromARGB(255, 130, 218, 215),
                blurRadius: 1,
                //spreadRadius: 1,
                offset: Offset(1, 1))
          ]),
      child: OutlinedButton(
          style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.transparent)),
          onPressed: () {
            NavigationService().navigateToScreen(CategoryPage());
          },
          child: Stack(
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.note_alt,
                    color: Color.fromARGB(255, 71, 90, 89),
                    size: 30,
                  )),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "        Loại công việc",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      height: 1.5,
                      fontSize: 18,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ))
            ],
          )),
    );
  }

  Widget _textCount(String text, Color color) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 22, color: color),
    );
  }

  Widget _bordertop() {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30),
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(color: Color.fromARGB(90, 0, 0, 0), width: 1))),
    );
  }

  Widget _btnAddFloating() {
    return Container(
      height: 50.0,
      width: 50.0,
      child: FittedBox(
        child: FloatingActionButton(
            onPressed: () {
              setState(() {});
              setState(() {
                startDate = DateTime.now();
                deadline = DateTime.now().add(Duration(minutes: 60));
              });
              showDialogCreateTask();
            },
            backgroundColor: Color.fromARGB(255, 95, 255, 218),
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 35,
            )),
      ),
    );
  }

  Widget _actionNoti() {
    return TextButton.icon(
        onPressed: () {},
        icon: Icon(
          Icons.notifications_outlined,
          color: Color.fromARGB(255, 221, 181, 73),
        ),
        label: Text(''));
  }

  void showDialogCreateTask() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            'Thêm công việc',
            style: TextStyle(color: Color.fromARGB(255, 99, 216, 204)),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 70,
                  width: 600,
                  child: Utility().TextFieldCustom(
                      'Tiêu đề',
                      titleController,
                      Icon(
                        Icons.text_fields_outlined,
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 100,
                  width: 600,
                  child: Utility().TextFieldCustom('Nội dung', detailController,
                      Icon(Icons.description_outlined)),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 70,
                  width: 600,
                  child: Utility().TextFieldCustom(
                      'Ghi chú', noteController, Icon(Icons.edit_note)),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 70,
                  width: 600,
                  child: dropDownCategories(),
                ),
                Container(
                  height: 50,
                  width: 600,
                  alignment: Alignment.centerLeft,
                  child: Row(children: [
                    TimePickerStartDate(),
                    Utility().DisplayDateTime(startDate!)
                  ]),
                ),
                Container(
                  height: 50,
                  width: 600,
                  alignment: Alignment.centerLeft,
                  child: Row(children: [
                    TimePickerDeadline(),
                    Utility().DisplayDateTime(deadline!)
                  ]),
                ),
                Container(
                  height: 50,
                  width: 600,
                  alignment: Alignment.center,
                  child: Row(children: [
                    Text(
                      '    Công việc quan trọng:      ',
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0), fontSize: 13),
                    ),
                    ImportantButton(),
                  ]),
                ),
              ],
            ),
          ),
          actions: [
            TextButton.icon(
              icon: Icon(
                Icons.clear_outlined,
                color: Color.fromARGB(255, 255, 0, 0),
                size: 30,
              ),
              onPressed: () {
                setState(() {
                  cancel();
                });
                NavigationService().goBack();
              },
              label: Text(
                '',
                style: TextStyle(
                    color: Color.fromARGB(255, 255, 0, 0), fontSize: 18),
              ),
            ),
            SizedBox(
              width: 150,
            ),
            TextButton.icon(
              icon: Icon(
                Icons.done_all,
                color: Color.fromARGB(255, 0, 177, 6),
                size: 30,
              ),
              onPressed: () {
                postTaskToFireStore();
                //printt();
                setState(() {
                  countall();
                });
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

  Widget ImportantButton() {
    return Container(
      child: Tooltip(
        message: "Đánh dấu việc quan trọng",
        child: LikeButton(
            size: 40,
            isLiked: isImportant,
            likeBuilder: (isLiked) {
              return Icon(
                Icons.star,
                color: (isLiked) ? Colors.yellow : Colors.grey,
                size: 40,
              );
            },
            onTap: onButtonTapped),
      ),
    );
  }

  Future<bool> onButtonTapped(bool isLiked) async {
    setState(() {
      isImportant = !isLiked;
    });
    return !isLiked;
  }

  Widget TimePickerStartDate() {
    return TextButton.icon(
      onPressed: () {
        setState(() {
          DatePicker.showDateTimePicker(context,
              showTitleActions: true,
              minTime: DateTime(2000, 1, 1),
              maxTime: DateTime(2099, 12, 31),
              onChanged: (date) {}, onConfirm: (date) {
            startDate = date;
            deadline = date.add(Duration(minutes: 30));
            NavigationService().goBack();
            showDialogCreateTask();
          },
              currentTime: (startDate == null) ? DateTime.now() : startDate,
              locale: LocaleType.vi);
        });
      },
      label: Text(
        'Bắt đầu',
        style: TextStyle(color: Colors.blue, fontSize: 13),
      ),
      icon: Icon(Icons.access_time),
    );
  }

  Widget TimePickerDeadline() {
    return TextButton.icon(
      onPressed: () {
        setState(() {
          DatePicker.showDateTimePicker(context,
              showTitleActions: true,
              minTime: startDate,
              maxTime: DateTime(2099, 12, 31),
              onChanged: (date) {}, onConfirm: (date) {
            deadline = date;
            NavigationService().goBack();
            showDialogCreateTask();
          },
              currentTime: (deadline == null) ? startDate : deadline,
              locale: LocaleType.vi);
        });
      },
      label: Text(
        'Kết thúc',
        style: TextStyle(color: Colors.blue, fontSize: 13),
      ),
      icon: Icon(Icons.access_time),
    );
  }

  postTaskToFireStore() async {
    var uuid = Uuid().v4();
    Random random = Random();
    TaskModel task = TaskModel();

    task.uid = uuid;
    task.title = titleController.text;
    task.detail = detailController.text;
    task.colorCode = random.nextInt(9).toString();
    task.createAt = DateTime.now();
    task.deadline = deadline;
    task.doneDate = DateTime(0001, 01, 01, 01, 01, 01);
    task.isDone = false;
    task.isImportant = isImportant;
    task.note = noteController.text;
    task.startDate = startDate;
    task.category = selectedValue;

    if (startDate != null &&
        deadline != null &&
        startDate!.compareTo(deadline!) < 0 &&
        selectedValue!.trim() != "") {
      await firebaseFirestore
          .collection("users")
          .doc(user!.uid)
          .collection("tasks")
          .doc(task.uid)
          .set(task.toMap());
      Fluttertoast.showToast(msg: "Đã thêm 1 công việc");
      NavigationService().goBack();
    } else if (startDate == null || deadline == null) {
      Fluttertoast.showToast(msg: 'Cần có thời gian bắt đầu trước kết thúc');
    } else {
      Fluttertoast.showToast(msg: 'Cần có loại công việc');
    }
  }

  List<int> _getDividersIndexes() {
    List<int> _dividersIndexes = [];
    for (var i = 0; i < (items.length * 2) - 1; i++) {
      //Dividers indexes will be the odd indexes
      if (i.isOdd) {
        _dividersIndexes.add(i);
      }
    }
    return _dividersIndexes;
  }

  List<DropdownMenuItem<String>> _addDividersAfterItems(List<String> items) {
    List<DropdownMenuItem<String>> _menuItems = [];
    for (var item in items) {
      _menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
              child: Divider(),
            ),
        ],
      );
    }
    return _menuItems;
  }

  Widget dropDownCategories() {
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
                    NavigationService().goBack();
                    showDialogCreateTask();
                  });
                })));
  }

  Future<void> getCategories() async {
    var snapshotCate = await firebaseFirestore
        .collection("users")
        .doc(user!.uid)
        .collection("categories")
        .get();

    List<CategoryModel> list = snapshotCate.docs
        .map((e) => CategoryModel().fromJson(e.data()))
        .toList();

    setState(() {
      for (var item in list) {
        items.add(item.categoryName!);
      }
    });
  }

  void cancel() {
    titleController.text = '';
    detailController.text = '';
    noteController.text = '';
    isImportant = false;
    startDate = DateTime.now();
    deadline = DateTime.now().add(Duration(minutes: 60));
  }

  Future<void> countall() async {
    var snapshotValue = await firebaseFirestore
        .collection("users")
        .doc(user!.uid)
        .collection("tasks")
        .get();

    List<TaskModel> list =
        snapshotValue.docs.map((e) => TaskModel().fromJson(e.data())).toList();

    List<TaskModel> listToday = [];

    List<TaskModel> listWeek = [];

    String startDate, deadline;

    // for today
    list.forEach(
      (element) {
        if (Utility().compareToday(
            element.startDate.toString(), element.deadline.toString())) {
          listToday.add(element);
        }
      },
    );

    //for current week
    DateTime now = DateTime.now();
    int currentDay = now.weekday;
    DateTime firstDayOfWeek = now.subtract(Duration(days: currentDay - 1));
    DateTime endDayOfWeek = firstDayOfWeek.add(Duration(days: 6));

    list.forEach(
      (element) {
        if (Utility().compareRangeTimeDate(element.startDate!,
            element.deadline!, firstDayOfWeek, endDayOfWeek)) {
          listWeek.add(element);
        }
      },
    );

    //for important task

    List<TaskModel> listImportant = [];
    for (var item in list) {
      if (item.isImportant!) {
        listImportant.add(item);
      }
    }

    //for done task

    List<TaskModel> listDone = [];
    for (var item in list) {
      if (item.isDone!) {
        listDone.add(item);
      }
    }

    setState(() {
      countAllTask = list.length.toString();
      countTodayTask = listToday.length.toString();
      countWeekTask = listWeek.length.toString();
      countImportantTask = listImportant.length.toString();
      countDoneTask = listDone.length.toString();
    });
  }
}
