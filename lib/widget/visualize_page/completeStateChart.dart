import 'package:bepro/Utility/utilities.dart';
import 'package:bepro/models/task_model.dart';
import 'package:bepro/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CompleteStateChart extends StatefulWidget {
  DateTime startDate;
  DateTime deadline;

  CompleteStateChart(
      {super.key, required this.startDate, required this.deadline});

  @override
  State<CompleteStateChart> createState() => _CompleteStateChartState();
}

class _CompleteStateChartState extends State<CompleteStateChart> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  final _formKey = GlobalKey<FormState>();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  double _early = 0;
  double _late = 0;

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
            margin: EdgeInsets.only(top: 5, left: 15),
            child: Row(
              children: [
                Icon(Icons.bookmark_outlined,
                    color: Color.fromARGB(217, 85, 255, 252)),
                Text(
                  "Hoàn thành sớm: ${_early.toStringAsFixed(0)} công việc",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5, left: 15),
            child: Row(
              children: [
                Icon(Icons.bookmark_outlined,
                    color: Color.fromARGB(211, 233, 106, 89)),
                Text(
                  "Hoàn thành trễ: ${_late.toStringAsFixed(0)} công việc",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          (_early == 0 && _late == 0)
              ? Container(
                height: 240,
                  margin: EdgeInsets.all(25),
                  child: Center(
                    child: Text(
                      'Tháng này chưa có công việc hoàn thành',
                      style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Color.fromARGB(172, 255, 82, 82)),
                    ),
                  ),
                )
              : Container(
                  width: 350,
                  child: SfCircularChart(series: <CircularSeries>[
                    // Render pie chart
                    PieSeries<ChartData, String>(
                        explode: true,
                        dataSource: chartData,
                        pointColorMapper: (ChartData data, _) => data.color,
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.y,
                        dataLabelMapper: (ChartData data, _) => data.text,
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true))
                  ])),
          Container(
            margin: EdgeInsets.only(
              left: 15,
              bottom: 15,
            ),
            child: Center(
              child: Text(
                'Biểu đồ thống kê trạng thái hoàn thành công việc tháng ${widget.startDate.month} / ${widget.startDate.year}',
                style: TextStyle(
                    fontSize: 16, color: Color.fromARGB(255, 70, 70, 70)),
              ),
            ),
          )
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
    List<TaskModel> listAccept = [];

    for (var item in list) {
      if (Utility().compareRangeTimeDate(
          item.startDate!, item.deadline!, widget.startDate, widget.deadline)) {
        listAccept.add(item);
      }
      ;
    }

    setState(() {
      for (var item in listAccept) {
        if (item.isDone!) {
          if (item.doneDate!.compareTo(item.deadline!) > 0) {
            _late++;
          } else {
            _early++;
          }
        }
      }
    });

    setState(() {
      chartData = [
        ChartData('Hoàn thành sớm', _early, Color.fromARGB(217, 85, 255, 252),
            'Hoàn thành: ${((_early * 100) / (_early + _late)).toStringAsFixed(0)}%'),
        ChartData('hoành thành Trễ', _late, Color.fromARGB(211, 233, 106, 89),
            'Chưa hoàn thành: ${((_late * 100) / (_early + _late)).toStringAsFixed(0)}% '),
      ];
    });
  }
}

class ChartData {
  final String x;
  final double y;
  final Color color;
  final String text;
  ChartData(this.x, this.y, this.color, this.text);
}
