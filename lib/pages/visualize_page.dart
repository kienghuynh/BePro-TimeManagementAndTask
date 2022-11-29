import 'package:bepro/Utility/CustomPickerMonth.dart';
import 'package:bepro/services/navigation_service.dart';
import 'package:bepro/Utility/utilities.dart';
import 'package:bepro/widget/visualize_page/groupsBarChart.dart';
import 'package:bepro/widget/visualize_page/groupsBarTime.dart';
import 'package:bepro/widget/visualize_page/pieDoneChart.dart';
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
        // Container(
        //   height: 400,
        //   width: double.maxFinite,
        //   margin: EdgeInsets.only(top: 25, left: 25, right: 25),
        //   padding: EdgeInsets.all(10),
        //   decoration: BoxDecoration(
        //       color: Color.fromARGB(255, 255, 255, 255),
        //       borderRadius: BorderRadius.circular(18),
        //       border: Border.all(color: Color.fromARGB(149, 194, 194, 194)),
        //       boxShadow: [
        //         BoxShadow(
        //             color: Colors.grey,
        //             blurRadius: 5,
        //             spreadRadius: 1,
        //             offset: Offset(4, 4))
        //       ]),
        //   child: Column(
        //     children: [
        //       ColumnChart(),
        //     ],
        //   ),
        // ),
        Container(
          height: 460,
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
                children: [
                  TextButton.icon(
                      onPressed: () {
                        showDialogPickerTime();
                      },
                      icon: Icon(Icons.calendar_month_outlined),
                      label: Text(
                        'Thống kê theo khoảng thời gian',
                        style: TextStyle(fontSize: 16),
                      ))
                ],
              ),
              
              (startDate != null && deadline != null )
                  ? ColumnTimeChart(startDate: startDate!, deadline: deadline!)
                  : Text('')
            ],
          ),
        ),
        Container(
          child: SizedBox(
            height: 15,
          ),
        )
        // Container(
        //   height: 460,
        //   width: double.maxFinite,
        //       margin: EdgeInsets.only(top: 25, left: 25, right: 25),
        //       padding: EdgeInsets.all(10),
        //       decoration: BoxDecoration(
        //           color: Color.fromARGB(255, 255, 255, 255),
        //           borderRadius: BorderRadius.circular(18),
        //           border: Border.all(color: Color.fromARGB(149, 194, 194, 194)),
        //           boxShadow: [
        //             BoxShadow(
        //                 color: Colors.grey,
        //                 blurRadius: 5,
        //                 spreadRadius: 1,
        //                 offset: Offset(4, 4))
        //           ]),

        //       child: Column(
        //         children: [
        //           PieImportantChart()
        //         ],
        //       ),
        // ),
      ]),
    );
  }

  Widget TimePickerStartDate() {
    return TextButton.icon(
      onPressed: () {
        setState(() {
          DatePicker.showDatePicker(context,
              showTitleActions: true,
              minTime: DateTime(2000, 1, 1),
              maxTime: DateTime(2099, 12, 31),
              onChanged: (date) {}, onConfirm: (date) {
            startDate = date;
            NavigationService().goBack();
            showDialogPickerTime();
            setState(() {
              ColumnTimeChart(
                startDate: startDate!,
                deadline: deadline!,
              );
              startDate = null;
              startDate = date;
            });
          },
              currentTime: (startDate == null) ? DateTime.now() : startDate,
              locale: LocaleType.vi);
        });
      },
      label: Text(
        'Từ',
        style: TextStyle(color: Colors.blue, fontSize: 18),
      ),
      icon: Icon(Icons.access_time),
    );
  }

  void showDialogPickerTime() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            'Chọn thời gian',
            style: TextStyle(color: Colors.blue),
          ),
          content: Container(
            height: 100,
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 50,
                      width: 200,
                      alignment: Alignment.centerLeft,
                      child: Row(children: [
                        TimePickerStartDate(),
                        (startDate != null)
                            ? Utility().DisplayDate(startDate!)
                            : Text('')
                      ]),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      height: 50,
                      width: 200,
                      alignment: Alignment.centerLeft,
                      child: Row(children: [
                        TimePickerDeadline(),
                        (deadline != null)
                            ? Utility().DisplayDate(deadline!)
                            : Text('')
                      ]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton.icon(
              icon: Icon(
                Icons.done_all,
                color: Color.fromARGB(255, 0, 177, 6),
                size: 30,
              ),
              onPressed: () {
                print('từ ${startDate} đến ${deadline}');
                NavigationService().goBack();
              },
              label: Text(
                '',
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 177, 6), fontSize: 18),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget TimePickerDeadline() {
    return TextButton.icon(
      onPressed: () {
        setState(() {
          DatePicker.showDatePicker(context,
              showTitleActions: true,
              minTime: startDate?.add(Duration(days: 1)),
              maxTime: DateTime(2099, 12, 31), onChanged: (date) {
            deadline = null;
          }, onConfirm: (date) {
            deadline = date;
            NavigationService().goBack();
            showDialogPickerTime();
            setState(() {
              ColumnTimeChart(
                startDate: startDate!,
                deadline: deadline!,
              );
              
            });
          },
              currentTime: (deadline == null) ? startDate : deadline,
              locale: LocaleType.vi);
        });
      },
      label: Text(
        'Đến',
        style: TextStyle(color: Colors.blue, fontSize: 18),
      ),
      icon: Icon(Icons.access_time),
    );
  }

  void showPickerMonth() {
    DatePicker.showPicker(context,
        pickerModel: CustomMonthPicker(
            minTime: DateTime(2000),
            maxTime: DateTime(2099),
            currentTime: DateTime.now()),
        onChanged: (month) {}, onConfirm: (month) {
      setState(() {
        startDate = DateTime(month.year, month.month, 1);
        deadline = DateTime(month.year, month.month + 1, 0);
      });
    }, locale: LocaleType.vi);
  }
}
