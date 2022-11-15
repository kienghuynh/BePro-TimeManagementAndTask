import 'package:bepro/models/task_model.dart';
import 'package:bepro/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PieDoneChart extends StatefulWidget {
  const PieDoneChart({super.key});

  @override
  State<PieDoneChart> createState() => _PieDoneChartState();
}

class _PieDoneChartState extends State<PieDoneChart> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  final _formKey = GlobalKey<FormState>();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  double done = 0;
  double notDone = 0;

  List<ChartData> chartData = [];

  @override
  void initState() {
    countDone();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top:15, left: 15),
          child: Row(
            children: [
              Icon(Icons.bookmark_outlined,
                  color: Color.fromARGB(255, 120, 231, 80)),
              Text("Đã hoàn thành: ${((done*100)/(done+notDone)).toStringAsFixed(0)}%", 
                style: TextStyle(fontSize: 16),),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 15, left: 15),
          child: Row(
            children: [
              Icon(Icons.bookmark_outlined,
                  color: Color.fromARGB(255, 83, 118, 91)),
              Text("Chưa hoàn thành: ${((notDone*100)/(done+notDone)).toStringAsFixed(0)}%",
              style: TextStyle(fontSize: 16),),
            ],
          ),
        ),
        Container(
          width: 250,
          child: SfCircularChart(series: <CircularSeries>[
          // Render pie chart
            PieSeries<ChartData, String>(
                      dataSource: chartData,
                      pointColorMapper: (ChartData data, _) => data.color,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y)
                ])),
        Container(
          margin: EdgeInsets.only(left: 15, bottom: 15, ),
          child: Text('Biểu đồ thống kê công việc đã và chưa hoàn thành', 
          style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 70, 70, 70)),),)
          ],
        ),
      
    );
  }

  Future<void> countDone() async {
    var snapshotValue = await firebaseFirestore
        .collection("users")
        .doc(user!.uid)
        .collection("tasks")
        //.where("isDone", isEqualTo: true)
        .get();

    List<TaskModel> list =
        snapshotValue.docs.map((e) => TaskModel().fromJson(e.data())).toList();
    List<TaskModel> listDone = [];
    List<TaskModel> listNotDone = [];

    for (var item in list) {
      if (item.isDone!) {
        listDone.add(item);
      } else {
        listNotDone.add(item);
      }
    }
    setState(() {
      done = listDone.length.toDouble();
      notDone = listNotDone.length.toDouble();
      chartData = [
        ChartData('Hoàn thành', done, Color.fromARGB(255, 120, 231, 80)),
        ChartData(
            'Chưa hoành thành', notDone, Color.fromARGB(255, 83, 118, 91)),
      ];
    });
  }
}

class ChartData {
  final String x;
  final double y;
  final Color color;
  ChartData(this.x, this.y, this.color);
}
