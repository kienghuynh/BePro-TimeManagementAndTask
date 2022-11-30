import 'package:bepro/Utility/CustomPickerMonth.dart';
import 'package:bepro/services/navigation_service.dart';
import 'package:bepro/Utility/utilities.dart';
import 'package:bepro/widget/visualize_page/completeStateChart.dart';
import 'package:bepro/widget/visualize_page/pieDoneChart.dart';
import 'package:bepro/widget/visualize_page/pieImportantChart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VisualizePage extends StatefulWidget {
  const VisualizePage({super.key});

  @override
  State<VisualizePage> createState() => _VisualizePageState();
}

class _VisualizePageState extends State<VisualizePage> {
  DateTime? startDate;
  DateTime? deadline;
  DateTime? confirm;
  DateTime nowStart =
      DateTime(DateTime.now().year, DateTime.now().month, 1, 0, 0, 0);
  DateTime nowEnd =
      DateTime(DateTime.now().year, DateTime.now().month + 1, 0, 0, 0, 0);
  bool? isFirst;

  @override
  void initState() {
    isFirst = true;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      //backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        title: Center(
          child: const Text(
            'Thống kê',
            style: TextStyle(color: Color.fromARGB(255, 99, 216, 204)),
          ),
        ),
        actions: [
          TextButton.icon(
              onPressed: () {
                showPickerMonth();
              },
              icon: Icon(
                Icons.search_outlined,
                size: 34,
                color: Color.fromARGB(255, 99, 216, 204),
              ),
              label: Text(''))
        ],
      ),
      body: _pageWidget(),
    ));
  }

  Widget _pageWidget() {
    return SingleChildScrollView(
      child: Column(children: [
        Container(
          height: 1320,
          width: double.maxFinite,
          margin: EdgeInsets.only(top: 25, left: 25, right: 25),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Color.fromARGB(149, 194, 194, 194)),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5,
                    spreadRadius: 1,
                    offset: Offset(4, 4))
              ]),
          child: Column(
            children: [
              Row(
                children: [],
              ),
              isFirst!
                  ? listChart(nowStart, nowEnd)
                  : (startDate != null && deadline != null)
                      ? listChart(startDate!, deadline!)
                      : Text('')
            ],
          ),
        ),
        Container(
          child: SizedBox(
            height: 15,
          ),
        )
      ]),
    );
  }

  Widget listChart(DateTime startDate, DateTime deadline) {
    return Container(
      height: 1295,
      child: Column(children: [
        Container(height: 420,child: PieDoneChart(startDate: startDate,deadline: deadline,)),
        Utility().BottomLine(),
        SizedBox(height: 10,),
        Container(height: 420,child: CompleteStateChart(startDate: startDate,deadline: deadline,)),
        Utility().BottomLine(),
        SizedBox(height: 10,),
        Container(height: 420,child: PieImportantChart(startDate: startDate,deadline: deadline,)),
        SizedBox(height: 10,),
      ]),
    );
  }

  void showPickerMonth() {
    DatePicker.showPicker(context,
        pickerModel: CustomMonthPicker(
            minTime: DateTime(2000),
            maxTime: DateTime(2099),
            currentTime: confirm != null ? confirm : DateTime.now()),
        onChanged: (month) {
      setState(() {
        isFirst = false;
        startDate = null;
        deadline = null;
      });
    }, onConfirm: (month) {
      setState(() {
        startDate = DateTime(month.year, month.month, 1);
        deadline = DateTime(month.year, month.month + 1, 0);
        confirm = month;
      });
    }, locale: LocaleType.vi);
  }
}
