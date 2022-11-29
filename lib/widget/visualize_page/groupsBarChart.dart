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

  List<_ChartData> data = [];
  List<_ChartData> data2 = [];
  List<_ChartData> data3 = [];
  List<_ChartData> data4 = [];
  List<_ChartData> data5 = [];

  double max = 0;

  late TooltipBehavior _tooltip;

  @override
  void initState() {
    count();

    _tooltip = TooltipBehavior(enable: true);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              primaryYAxis:
                  NumericAxis(minimum: 0, maximum: max * 1.1, interval: 1),
              tooltipBehavior: _tooltip,
              series: <ChartSeries<_ChartData, String>>[
                BarSeries<_ChartData, String>(
                    dataSource: data2,
                    xValueMapper: (_ChartData data, _) => data.x,
                    yValueMapper: (_ChartData data, _) => data.y,
                    name: 'Số lượng',
                    color: Color.fromARGB(255, 230, 224, 52)),
                BarSeries<_ChartData, String>(
                    dataSource: data,
                    xValueMapper: (_ChartData data, _) => data.x,
                    yValueMapper: (_ChartData data, _) => data.y,
                    name: 'Số lượng',
                    color: Color.fromARGB(255, 154, 154, 152)),
                BarSeries<_ChartData, String>(
                    dataSource: data4,
                    xValueMapper: (_ChartData data, _) => data.x,
                    yValueMapper: (_ChartData data, _) => data.y,
                    name: 'Số lượng',
                    color: Color.fromARGB(255, 50, 134, 50)),
                BarSeries<_ChartData, String>(
                    dataSource: data5,
                    xValueMapper: (_ChartData data, _) => data.x,
                    yValueMapper: (_ChartData data, _) => data.y,
                    name: 'Số lượng',
                    color: Color.fromARGB(255, 158, 232, 158)),
                BarSeries<_ChartData, String>(
                    dataSource: data3,
                    xValueMapper: (_ChartData data, _) => data.x,
                    yValueMapper: (_ChartData data, _) => data.y,
                    name: 'Số lượng',
                    color: Color.fromARGB(255, 86, 235, 86)),
              ]),
        ),
        SizedBox(height: 30,),
        Container(child: Center(child: Text('Biểu đồ thông kê số lượng công việc',
          style: TextStyle(fontSize: 18),),),)
      ],
    );
  }

  Future<void> count() async {
    var snapshotValue = await firebaseFirestore
        .collection("users")
        .doc(user!.uid)
        .collection("tasks")
        .get();

    double _done = 0;
    double _not = 0;
    double _early = 0;
    double _late = 0;
    double _impor = 0;
    

    List<TaskModel> list =
        snapshotValue.docs.map((e) => TaskModel().fromJson(e.data())).toList();

    for (var item in list) {
      if (item.isDone == true) {
        _done++;
        if (item.doneDate!.compareTo(item.deadline!) > 0) {
          _late++;
        } else {
          _early++;
        }
      } else {
        _not++;
      }

      if (item.isImportant == true) {
        _impor++;
      }
    }
    

    List<double> listcount = [_done, _not, _early, _late, _impor];
    double maxi = listcount[0];
    for (int i = 0; i < listcount.length; i++) {
      if (maxi < listcount[i]) {
        maxi = listcount[i];
      }
    }
    print(maxi.toString());
    setState(() {
      max = maxi;
      data = [
        _ChartData('Chưa hoàn thành', _not),
      ];
      data2 = [
        _ChartData('Quan trọng', _impor),
      ];
      data3 = [
        _ChartData('Đã hoàn thành', _done),
      ];
      data4 = [_ChartData('Trễ', _late)];
      data5 = [_ChartData('Sớm', _early)];
    });
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
