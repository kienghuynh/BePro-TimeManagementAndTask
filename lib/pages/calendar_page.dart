import 'package:bepro/models/task_model.dart';
import 'package:bepro/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  final _formKey = GlobalKey<FormState>();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromARGB(255, 221, 181, 73),
          Color.fromARGB(255, 99, 216, 204)
        ], begin: Alignment.topLeft, end: Alignment.bottomRight),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: const BackButton(
            color: Color.fromARGB(255, 221, 181, 73),
          ),
          backgroundColor: Colors.white,
          title: const Text(
            '',
            style: TextStyle(color: Color.fromARGB(255, 221, 181, 73)),
          ),
        ),
        body: _pageWidget(),
      ),
    );
  }

  Widget _pageWidget() {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(left: 10, top: 15, right: 10, bottom: 15),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _bodyCalendar(),
                          // ElevatedButton(
                          //     onPressed: getEvent, child: Text('excute'))
                        ],
                      ),
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }

  Widget _bodyCalendar() {
    return Container(
      height: 570,
      child: SfCalendar(
        firstDayOfWeek: 1,
        
        view: CalendarView.month,
        monthViewSettings: MonthViewSettings(
          //navigationDirection: MonthNavigationDirection.horizontal,
          showAgenda: true,
          agendaViewHeight: 150,
          appointmentDisplayCount: 2,
          agendaItemHeight: 40,
          agendaStyle: AgendaStyle(
            
            appointmentTextStyle: TextStyle(
              fontSize: 16
            )
          ),
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment
          ),
        dataSource: EventData(getEvent()),
      ),
    );
  }

  List<Appointment> getEvent() {
    // đọc được dữ liệu nhưng không gán vào 1 cái list được.
    //giá trị trong hàm "then" không kéo ra ngoài được
    List<Appointment> events = <Appointment>[];
    //TaskModel itemStamp;
    List<TaskModel> items = <TaskModel>[];
    firebaseFirestore
        .collection("users")
        .doc(user!.uid)
        .collection("tasks")
        .get()
        .then((value) => {
              // value.docs.forEach((result) {
              //   itemStamp = TaskModel().fromJson(result.data());
              // }),
            });
    

    events.add(Appointment(
        startTime: DateTime.now().add(Duration(days: -2)),
        endTime: DateTime.now().add(Duration(days: -1)),
        //isAllDay: true,
        subject: 'Học tiếng anh',
        color: Colors.blue));

    events.add(Appointment(
        startTime: DateTime.now().add(Duration(days: -5)),
        endTime: DateTime.now().add(Duration(days: -4)),
        //isAllDay: true,
        subject: 'Viết Báo cáo KLTN',
        color: Colors.red));
    
    events.add(Appointment(
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        isAllDay: true,
        subject: 'Báo cáo KLTN',
        color: Color.fromARGB(255, 163, 102, 48)));
    
    

    debugPrint(' event ${events.length.toString()}');
    return events;
  }
}

class EventData extends CalendarDataSource {
  EventData(List<Appointment> source) {
    appointments = source;
  }
}
