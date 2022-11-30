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

class PieImportantChart extends StatefulWidget {
  DateTime startDate;
  DateTime deadline;

  PieImportantChart(
      {super.key, required this.startDate, required this.deadline});

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
                    color: Color.fromARGB(255, 251, 255, 36)),
                Text(
                  "Quan trọng: ${im.toStringAsFixed(0)} công việc",
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
                    color: Color.fromARGB(255, 157, 157, 157)),
                Text(
                  "Không quan trọng: ${notIm.toStringAsFixed(0)} công việc",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          (im==0 && notIm ==0)
          ? Container(
            height: 240,
              margin: EdgeInsets.all(25),
              child: Center(
                        child: Text('Tháng này không có công việc', 
                          style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Color.fromARGB(172, 255, 82, 82)),),),)
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
                    dataLabelSettings: const DataLabelSettings(isVisible: true))
              ])),
          Container(
            margin: EdgeInsets.only(
              left: 15,
              bottom: 15,
            ),
            child: Center(
              child: Text(
                'Biểu đồ thống kê công việc quan trọng tháng ${widget.startDate.month} / ${widget.startDate.year}',
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
        if (item.isImportant!) {
          im++;
        } else {
          notIm++;
        }
      }
    });

    setState(() {
      chartData = [
        ChartData('Quan trọng', im, Color.fromARGB(255, 251, 255, 36),
            'Quan trọng: ${((im * 100) / (im + notIm)).toStringAsFixed(0)}%'),
        ChartData('Không quan trọng', notIm, Color.fromARGB(255, 157, 157, 157),
            'Không quan trọng: ${((notIm * 100) / (im + notIm)).toStringAsFixed(0)}% '),
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
