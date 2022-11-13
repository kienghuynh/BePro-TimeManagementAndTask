import 'dart:math';

import 'package:bepro/models/appointment_model.dart';
import 'package:bepro/models/task_model.dart';
import 'package:bepro/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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

  List<Color> _colorCollection = <Color>[];
  EventData? events;

  @override
  void initState() {
    _initializeEventColor();
    getDataFromeFirestore().then((result) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {});
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
      // decoration: const BoxDecoration(
      //   gradient: LinearGradient(colors: [
      //     Color.fromARGB(255, 0, 0, 0),
      //     Color.fromARGB(255, 0, 0, 0)
      //   ], begin: Alignment.topLeft, end: Alignment.bottomRight),
      // ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          
          backgroundColor: Colors.white,
          title: Center(
            child: const Text(
                'Lịch công việc',
                style: TextStyle(color: Color.fromARGB(255, 99, 216, 204)),
              ),
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
                          //     onPressed: getDataFromeFirestore,
                          //     child: Text('excute'))
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
      height: 850,
      child: SfCalendar(
        headerStyle: CalendarHeaderStyle(
          textAlign: TextAlign.center
        ),
        firstDayOfWeek: 1,
        view: CalendarView.month,
        monthViewSettings: MonthViewSettings(
          
            //navigationDirection: MonthNavigationDirection.horizontal,
            showAgenda: true,
            agendaViewHeight: 120,
            appointmentDisplayCount: 3,
            agendaItemHeight: 35,
            agendaStyle: AgendaStyle(
                appointmentTextStyle:
                    TextStyle(fontSize: 17, color: Colors.black)),
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
        dataSource: events,
      ),
    );
  }

  Future<void> getDataFromeFirestore() async {
    var snapshotValue = await firebaseFirestore
        .collection("users")
        .doc(user!.uid)
        .collection("tasks")
        .get();

    final Random random = new Random();
    List<AppointmentModel> list =
        snapshotValue.docs.map((e) => AppointmentModel().fromJson(e.data())).toList();
    List<Appointment> listEvent = <Appointment>[];
    list.forEach(
      (element) {
        
        listEvent.add(Appointment(
            startTime: element.startDate as DateTime,
            endTime: element.deadline as DateTime,
            color:
                _colorCollection[element.colorCode as int],
            subject: element.title.toString()));
      },
    );
    setState(() {
      events = EventData(listEvent);
    });
  }

  void _initializeEventColor() {
    _colorCollection.add(Color.fromARGB(255, 255, 84, 84));
    _colorCollection.add(Color.fromARGB(255, 255, 141, 47));
    _colorCollection.add(Color.fromARGB(255, 81, 255, 68));
    _colorCollection.add(Color.fromARGB(255, 75, 205, 39));
    _colorCollection.add(Color.fromARGB(255, 60, 255, 252));
    _colorCollection.add(Color.fromARGB(255, 63, 191, 255));
    _colorCollection.add(Color.fromARGB(255, 58, 71, 255));
    _colorCollection.add(Color.fromARGB(255, 172, 71, 255));
    _colorCollection.add(Color.fromARGB(255, 255, 72, 243));
    _colorCollection.add(Color.fromARGB(255, 169, 103, 62));
  }
}

class EventData extends CalendarDataSource {
  EventData(List<Appointment> source) {
    appointments = source;
  }
}
