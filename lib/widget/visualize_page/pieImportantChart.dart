import 'package:bepro/models/task_model.dart';
import 'package:bepro/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PieImportantChart extends StatefulWidget {
  const PieImportantChart({super.key});

  @override
  State<PieImportantChart> createState() => _PieImportantChartState();
}

class _PieImportantChartState extends State<PieImportantChart> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  final _formKey = GlobalKey<FormState>();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  double im = 0;
  double notIm = 0;

  List<ChartData> chartData = [];

  @override
  void initState() {
    countImportant();
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
                  color: Color.fromARGB(255, 255, 241, 47)),
              Text("Việc quan trọng: ${((im*100)/(im+notIm)).toStringAsFixed(0)}%", 
                style: TextStyle(fontSize: 16),),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 15, left: 15),
          child: Row(
            children: [
              Icon(Icons.bookmark_outlined,
                  color: Color.fromARGB(255, 136, 134, 18)),
              Text("Việc không quan trọng: ${((notIm*100)/(im+notIm)).toStringAsFixed(0)}%",
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
          child: Text('Biểu đồ thống kê công việc quan trong và không quan trọng', 
          style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 70, 70, 70)),),)
          ],
        ),
      
    );
  }

  Future<void> countImportant() async {
    var snapshotValue = await firebaseFirestore
        .collection("users")
        .doc(user!.uid)
        .collection("tasks")
        //.where("isDone", isEqualTo: true)
        .get();

    List<TaskModel> list =
        snapshotValue.docs.map((e) => TaskModel().fromJson(e.data())).toList();
    List<TaskModel> listIm = [];
    List<TaskModel> listnotIm = [];

    for (var item in list) {
      if (item.isImportant!) {
        listIm.add(item);
      } else {
        listnotIm.add(item);
      }
    }
    setState(() {
      im = listIm.length.toDouble();
      notIm = listnotIm.length.toDouble();
      chartData = [
        ChartData('Hoàn thành', im, Color.fromARGB(255, 255, 241, 47)),
        ChartData(
            'Chưa hoành thành', notIm, Color.fromARGB(255, 136, 134, 18)),
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
