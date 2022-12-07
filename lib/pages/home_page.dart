import 'package:bepro/Utility/utilities.dart';
import 'package:bepro/models/task_model.dart';
import 'package:bepro/pages/calendar_page.dart';
import 'package:bepro/pages/profile_page.dart';
import 'package:bepro/pages/task_page.dart.dart';
import 'package:bepro/pages/visualize_page.dart';
import 'package:bepro/services/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cron/cron.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _navigatorBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _pages = [
    TaskPage(),
    CalendarPage(),
    VisualizePage(),
    ProfilePage(),
  ];

  Cron cron = Cron();

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  User? user = FirebaseAuth.instance.currentUser;
  String countAllTask = '';
  String countTodayTask = '';
  String countImportantTask = '';
  String countDoneTask = '';
  String countWeekTask = '';
  String countWillLate = '';

  NotificationService _notificationService = NotificationService();
  @override
  void initState() {
    countall();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: _bottomBar(),
    );
  }

  Widget _bottomBar() {
    return Container(
      color: Color.fromARGB(255, 255, 255, 255),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: GNav(
            gap: 10,
            onTabChange: _navigatorBottomBar,
            tabBackgroundColor: Color.fromARGB(255, 99, 216, 204),
            color: Color.fromARGB(255, 99, 216, 204),
            activeColor: Color.fromARGB(255, 255, 255, 255),
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            tabActiveBorder:
                Border.all(color: Color.fromARGB(255, 99, 216, 204), width: 1),
            //curve: Curves.decelerate,
            hoverColor: Color.fromARGB(255, 255, 255, 255),
            duration: Duration(milliseconds: 500),
            padding: EdgeInsets.all(10),
            tabs: [
              GButton(
                icon: Icons.home_outlined,
                text: "Trang chủ",
                textStyle: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                iconSize: 24,
              ),
              GButton(
                icon: Icons.calendar_month_outlined,
                text: "Lịch",
                textStyle: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                iconSize: 24,
              ),
              GButton(
                icon: Icons.assessment_outlined,
                text: "Thống kê",
                textStyle: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                iconSize: 24,
              ),
              GButton(
                icon: Icons.account_circle_outlined,
                text: "Cá nhân",
                textStyle: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                iconSize: 24,
              ),
            ]),
      ),
    );
  }

  Future<void> countall() async {
    var snapshotValue = await firebaseFirestore
        .collection("users")
        .doc(user!.uid)
        .collection("tasks")
        .get();

    List<TaskModel> list =
        snapshotValue.docs.map((e) => TaskModel().fromJson(e.data())).toList();

    List<TaskModel> listLate = [];
    DateTime now = DateTime.now();
    for (var item in list) {
      //loại những việc đã hết hạn
      
        if (now.add(Duration(days: 3)).compareTo(item.deadline!)>=0 && now.compareTo(item.deadline!)<0)  {
        listLate.add(item);
      
      }
    }

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
      countWillLate = listLate.length.toString();
    });

    cron.schedule(Schedule.parse('0 8 */1 * *'), () async {
      //cron.schedule(Schedule.parse('*/5 * * * * *'), () async {
      init();
      print('Run cron');
    });
  }

  void init() {
    _notificationService.initializationNotification();
    _notificationService.sendNotification(countTodayTask, countWillLate);
    print('run init');
  }

  void cancel() {
    _notificationService.stopNotification();
  }
}
