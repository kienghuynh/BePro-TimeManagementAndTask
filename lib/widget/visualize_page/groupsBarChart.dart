import 'package:bepro/models/task_model.dart';
import 'package:bepro/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ColumnChart extends StatefulWidget {
  const ColumnChart({super.key});

  @override
  State<ColumnChart> createState() => _ColumnChartState();
}

class _ColumnChartState extends State<ColumnChart> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  final _formKey = GlobalKey<FormState>();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  late List<_ChartData> data;
  late List<_ChartData> data1;
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    _tooltip = TooltipBehavior(enable: true);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(minimum: 0, maximum: 40, interval: 10),
          tooltipBehavior: _tooltip,
          series: <ChartSeries<_ChartData, String>>[
            ColumnSeries<_ChartData, String>(
                dataSource: data1,
                xValueMapper: (_ChartData data, _) => data.x,
                yValueMapper: (_ChartData data, _) => data.y,
                name: 'Gold',
                color: Color.fromARGB(255, 98, 131, 159)),
            ColumnSeries<_ChartData, String>(
                dataSource: data,
                xValueMapper: (_ChartData data, _) => data.x,
                yValueMapper: (_ChartData data, _) => data.y,
                name: 'cat',
                color: Color.fromRGBO(8, 142, 255, 1))
          ]),
    );
  }

  // Future<void> countDone() async {
  //   var snapshotValue = await firebaseFirestore
  //       .collection("users")
  //       .doc(user!.uid)
  //       .collection("tasks")
  //       .where("isDone", isEqualTo: true)
  //       .get();

  //   List<TaskModel> list =
  //       snapshotValue.docs.map((e) => TaskModel().fromJson(e.data())).toList();
  //   List<TaskModel> listDone = [];
  //   setState(() {
  //     countDoneTask = list.length.toString();
  //   });
  // }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
