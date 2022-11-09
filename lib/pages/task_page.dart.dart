import 'package:bepro/models/task_model.dart';
import 'package:bepro/models/user_model.dart';
import 'package:bepro/pages/calendar_page.dart';
import 'package:bepro/pages/login_page.dart';
import 'package:bepro/pages/allTask_page.dart';
import 'package:bepro/services/navigation_service.dart';
import 'package:bepro/widget/home_page/clock_text.dart';
import 'package:bepro/widget/home_page/clock_text_week.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:timer_builder/timer_builder.dart';

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

  String countAllTask = '';

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
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromARGB(255, 221, 181, 73),
          Color.fromARGB(255, 99, 216, 204)
        ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        // image: DecorationImage(
        //   alignment: Alignment(0, -0.4),
        //   image: ExactAssetImage('assets/background-login.png'),
        // ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: Color.fromARGB(255, 221, 181, 73)),
          backgroundColor: Colors.white,
          title: const Text(
            '',
            style: TextStyle(color: Color.fromARGB(255, 221, 181, 73)),
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
                  Icons.assignment_turned_in_outlined,
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
              //NavigationService().navigateToScreen(CalendarPage());
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

  Widget _introText() {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Icon(
                Icons.waving_hand_outlined,
                color: Colors.white,
                size: 40,
              ),
              Text(
                '  Hi ${loggedInUser.fullName}',
                style: TextStyle(
                    fontSize: 22,
                    fontStyle: FontStyle.italic,
                    color: Colors.white),
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Text(
                'Hom nay bạn muốn làm gì ?',
                style: TextStyle(
                    fontSize: 24,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255)),
              )
            ],
          ),
          Row(
            children: [
              Text(
                'Hãy để BePro giúp bạn nhé !',
                style: TextStyle(
                    fontSize: 24,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255)),
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
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
