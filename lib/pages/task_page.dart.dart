import 'dart:math';

import 'package:bepro/models/task_model.dart';
import 'package:bepro/models/user_model.dart';
import 'package:bepro/pages/calendar_page.dart';
import 'package:bepro/pages/login_page.dart';
import 'package:bepro/pages/allTask_page.dart';
import 'package:bepro/services/navigation_service.dart';
import 'package:bepro/widget/home_page/clock_text.dart';
import 'package:bepro/widget/home_page/clock_text_week.dart';
import 'package:bepro/widget/utilities.dart';
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
  bool isImportant = false;

  DateTime? startDate;
  DateTime? deadline;
  bool pressedStartDate = false;
  bool pressedDeadline = false;

  @override
  void initState() {
    super.initState();
    count();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: const BoxDecoration(
      //   gradient: LinearGradient(colors: [
      //     Color.fromARGB(255, 221, 181, 73),
      //     Color.fromARGB(255, 99, 216, 204)
      //   ], begin: Alignment.topLeft, end: Alignment.bottomRight),
      //   // image: DecorationImage(
      //   //   alignment: Alignment(0, -0.4),
      //   //   image: ExactAssetImage('assets/background-login.png'),
      //   // ),
      // ),
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
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.settings),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              ),
            ),
          ],
        ),
        body: _pageWidget(),
        extendBody: true,
        floatingActionButton: _btnAddFloating(),
        endDrawer: _drawerMenu(),
      ),
    );
  }

  Widget _pageWidget() {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(left: 30, top: 30, right: 30),
          child: Form(
              key: _formKey,
              child: Column(children: [
                //_introText(),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _allTaskButton(),
                            flex: 4,
                          ),
                          //Expanded(child: SizedBox(),),
                          Expanded(
                            child: _textCount(
                                countAllTask, Color.fromARGB(255, 0, 0, 0)),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      _bordertop(),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _todayButton(),
                            flex: 4,
                          ),
                          //Expanded(child: SizedBox(),),
                          Expanded(
                            child:
                                _textCount("0", Color.fromARGB(255, 0, 0, 0)),
                          )
                        ],
                      ),
                      Row(
                        children: [ClockText()],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      _bordertop(),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(child: _nextweekButton(), flex: 4),
                          Expanded(
                            flex: 1,
                            child:
                                _textCount("0", Color.fromARGB(255, 0, 0, 0)),
                          )
                        ],
                      ),
                      Row(
                        children: [ClockTextWeek()],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      _bordertop(),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(child: _upcomingButton(), flex: 4),
                          Expanded(
                            child:
                                _textCount("0", Color.fromARGB(255, 0, 0, 0)),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      _bordertop(),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(child: _importantButton(), flex: 4),
                          Expanded(
                            child:
                                _textCount("0", Color.fromARGB(255, 0, 0, 0)),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      _bordertop(),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(child: _completedButton(), flex: 4),
                          Expanded(
                            child:
                                _textCount("0", Color.fromARGB(255, 0, 0, 0)),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                _bordertop(),
                SizedBox(
                  height: 15,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      _NotedButton(),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                )
              ])),
        ),
      ),
    );
  }

  Widget _drawerMenu() {
    return Drawer(
      backgroundColor: Colors.grey.shade300,
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [_headerDrawer(), _drawerList()],
          ),
        ),
      ),
    );
  }

  Widget _headerDrawer() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [
          Color.fromARGB(255, 221, 181, 73),
          Color.fromARGB(255, 99, 216, 204)
        ],
      )),
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.only(top: 5.0),
      child: Column(
        children: [
          SizedBox(
            height: 70,
          ),
          _image('assets/person.png', 50),
          _profileText("${loggedInUser.fullName}"),
          _profileText("${loggedInUser.email}"),
        ],
      ),
    );
  }

  Widget _drawerList() {
    return Container(
        padding: EdgeInsets.only(
          top: 15,
        ),
        child: Column(
            // shows the list of menu drawer
            children: [
              _createTextButtonDrawer('Cập nhật thông tin cá nhân',
                  Icon(Icons.recent_actors_outlined)),
              _createTextButtonDrawer(
                  'Đổi mật khẩu', Icon(Icons.settings_outlined)),
              _createTextButtonDrawer('Cài đặt', Icon(Icons.settings_outlined)),
              _createTextButtonDrawer(
                  'Chính sách', Icon(Icons.policy_outlined)),
              _createTextButtonDrawer(
                  'Gửi đánh giá', Icon(Icons.feedback_outlined)),
              Container(
                padding: EdgeInsets.all(25),
                child: _logoutButton(),
              ),
            ]));
  }

  Widget _createTextButtonDrawer(String text, Icon icon) {
    return TextButton.icon(
        icon: icon,
        label: Text('$text',
            textAlign: TextAlign.center,
            style:
                TextStyle(fontSize: 20, color: Color.fromARGB(255, 0, 0, 0))),
        onPressed: () {});
  }

  Widget _profileText(String string) {
    return Text(
      '$string',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 18, color: Colors.white),
    );
  }

  Widget _image(String url, double height) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          alignment: Alignment(0, -0.8),
          image: AssetImage('$url'),
        ),
      ),
      height: height,
    );
  }

  Widget _logoutButton() {
    return ElevatedButton(
      onPressed: () {
        logOut();
      },
      child: const SizedBox(
        width: double.infinity,
        child: Text(
          'Đăng xuất',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
      style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(side: BorderSide(color: Colors.black)),
          primary: Colors.white,
          onPrimary: Color.fromARGB(255, 78, 169, 160),
          padding: EdgeInsets.symmetric(vertical: 16)),
    );
  }

  Widget _nextweekButton() {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.transparent)),
        onPressed: () {},
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
                  "        Tuần sau",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    height: 1.5,
                    fontSize: 18,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ))
          ],
        ));
  }

  Widget _allTaskButton() {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.transparent)),
        onPressed: () {
          NavigationService().navigateToScreen(AllTaskPage());
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
                  "        Tất cả",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    height: 1.5,
                    fontSize: 18,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ))
          ],
        ));
  }

  Widget _todayButton() {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.transparent)),
        onPressed: () {
          //NavigationService().navigateToScreen(TodayPage());
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
                  "        Hôm nay",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    height: 1.5,
                    fontSize: 18,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ))
          ],
        ));
  }

  Widget _upcomingButton() {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.transparent)),
        onPressed: () {},
        child: Stack(
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                  Icons.calendar_month_outlined,
                  color: Color.fromARGB(255, 54, 255, 238),
                  size: 30,
                )),
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "        Sắp tới",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    height: 1.5,
                    fontSize: 18,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ))
          ],
        ));
  }

  Widget _importantButton() {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.transparent)),
        onPressed: () {},
        child: Stack(
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                  Icons.grade_outlined,
                  color: Color.fromARGB(255, 255, 218, 35),
                  size: 30,
                )),
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "        Quan trọng",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    height: 1.5,
                    fontSize: 18,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ))
          ],
        ));
  }

  Widget _completedButton() {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.transparent)),
        onPressed: () {},
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
                  "        Đã hoàn thành",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    height: 1.5,
                    fontSize: 18,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ))
          ],
        ));
  }

  Widget _NotedButton() {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.transparent)),
        onPressed: () {},
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
                  "        Ghi chú",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    height: 1.5,
                    fontSize: 18,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ))
          ],
        ));
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
      height: 70.0,
      width: 70.0,
      child: FittedBox(
        child: FloatingActionButton(
            onPressed: () {
              showDialogCreateTask();
            },
            backgroundColor: Color.fromARGB(255, 95, 255, 100),
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
                      )),),
                  SizedBox(height: 10,),
                  Container(
                    height: 100,
                    width: 600,
                    child: Utility().TextFieldCustom('Nội dung', detailController,
                       Icon(Icons.description_outlined)),),
                  SizedBox(height: 10,),
                  Container(
                    height: 70,
                    width: 600,
                    child: Utility().TextFieldCustom(
                      'Ghi chú', noteController, Icon(Icons.edit_note)),),
                  SizedBox(height: 10,),
                  Container(
                    height: 50,
                    width: 600,
                    alignment: Alignment.centerLeft,
                    child: Row(children:[ 
                      TimePickerStartDate(),
                      pressedStartDate ? _displayDateTime(startDate!) : Text('')]),),
                  Container(
                    height: 50,
                    width: 600,
                    alignment: Alignment.centerLeft,
                    child: Row(children:[ 
                      TimePickerDeadline(),
                      pressedDeadline ? _displayDateTime(deadline!) : Text('')]),),
                  Container(
                    height: 50,
                    width: 600,
                    alignment: Alignment.center,
                    child: Row(children:[Text('    Công việc quan trọng:      ',style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 18),), 
                      ImportantButton(),]),),
                  // Expanded(
                  //   flex: 1,
                  //   child: Utility().TextFieldCustom(
                  //     'Tiêu đề',
                  //     titleController,
                  //     Icon(
                  //       Icons.text_fields_outlined,
                  //     )),),
                  // Expanded(child: SizedBox(),),
                  // Expanded(child: Utility().TextFieldCustom('Nội dung', detailController,
                  //     Icon(Icons.description_outlined)), flex: 1,),
                  // Expanded(child: SizedBox()),
                  // Expanded(child: Utility().TextFieldCustom(
                  //     'Ghi chú', noteController, Icon(Icons.edit_note)), flex: 1,),
                  // Expanded(
                  //   child: SizedBox(),
                  // ),
                  // Expanded(child: TimePickerStartDate()),
                  // Expanded(child: pressedStartDate ? _displayDateTime(startDate!) : Text(''),),
                  // Expanded(child: TimePickerDeadline()),
                  // Expanded(child: pressedDeadline ? _displayDateTime(deadline!) : Text(''),),
                  // Expanded(child: ImportantButton()),
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
                setState(() {
                  count();
                });
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

  Widget ImportantButton() {
    return Container(
      child: Tooltip(
        message: "Đánh dấu việc quan trọng",
        child: LikeButton(
            size: 40,
            //isLiked: true,
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

  Widget TimePickerStartDate() {
    return TextButton.icon(
      onPressed: () {
        setState(() {
          pressedStartDate = true;
          DatePicker.showDateTimePicker(context,
              showTitleActions: true,
              minTime: DateTime(2000, 1, 1),
              maxTime: DateTime(2099, 12, 31), onChanged: (date) {

          }, onConfirm: (date) {
            startDate = date;
            NavigationService().goBack();
            showDialogCreateTask();
          },
              currentTime: (startDate == null) ? DateTime.now() : startDate,
              locale: LocaleType.vi);
        });
      },
      label: Text(
        'Bắt đầu',
        style: TextStyle(color: Colors.blue, fontSize: 18),
      ),
      icon: Icon(Icons.access_time),
    );
  }

  Widget TimePickerDeadline() {
    return TextButton.icon(
      onPressed: () {
        setState(() {
          pressedDeadline = true;
          DatePicker.showDateTimePicker(context,
              showTitleActions: true,
              minTime: DateTime(2000, 1, 1),
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
        style: TextStyle(color: Colors.blue, fontSize: 18),
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
    task.doneDate = startDate!.add(Duration(days: 1));
    task.isDone = false;
    task.isImportant = isImportant;
    task.note = noteController.text;
    task.startDate = startDate;

    await firebaseFirestore
        .collection("users")
        .doc(user!.uid)
        .collection("tasks")
        .doc(task.uid)
        .set(task.toMap());
    print(countAllTask);
    Fluttertoast.showToast(msg: "Đã thêm 1 công việc");
  }

  void cancel() {
    titleController.text = '';
    detailController.text = '';
    noteController.text = '';
  }

  @override
  Widget _displayDateTime(DateTime date) {
    return Center(
        child: Text(
      "${date.hour}:${date.minute} ${date.day}/${date.month}/${date.year}",
      style: TextStyle(
          fontSize: 18, color: Colors.blue, fontWeight: FontWeight.w500),
    ));
  }

  Future<bool> onButtonTapped(bool isLiked) async {
    setState(() {
      isImportant = !isLiked;
    });
    return !isLiked;
  }

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
    NavigationService().replaceScreen(LoginPage());
  }

  Future<void> count() async {
    var snapshotValue = await firebaseFirestore
        .collection("users")
        .doc(user!.uid)
        .collection("tasks")
        .get();

    List<TaskModel> list =
        snapshotValue.docs.map((e) => TaskModel().fromJson(e.data())).toList();

    setState(() {
      countAllTask = list.length.toString();
    });
  }
}
