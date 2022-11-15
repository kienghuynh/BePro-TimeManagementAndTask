import 'package:bepro/widget/visualize_page/groupsBarChart.dart';
import 'package:bepro/widget/visualize_page/pieDoneChart.dart';
import 'package:bepro/widget/visualize_page/pieImportantChart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';

class VisualizePage extends StatefulWidget {
  const VisualizePage({super.key});

  @override
  State<VisualizePage> createState() => _VisualizePageState();
}

class _VisualizePageState extends State<VisualizePage> {
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
      ),
      body: _pageWidget(),
    ));
  }

  Widget _pageWidget() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 460,
            width: double.maxFinite,
                margin: EdgeInsets.all(25),
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
                    PieDoneChart()
                  ],
                ),

          ),
          Container(
            height: 460,
            width: double.maxFinite,
                margin: EdgeInsets.all(25),
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
                    PieImportantChart()
                  ],
                ),

          ),
      //     Container(
            
      //           margin: EdgeInsets.all(25),
      //           padding: EdgeInsets.all(10),
      //           decoration: BoxDecoration(
      //               color: Color.fromARGB(255, 255, 255, 255),
      //               borderRadius: BorderRadius.circular(18),
      //               border: Border.all(color: Color.fromARGB(149, 194, 194, 194)),
      //               boxShadow: [
      //                 BoxShadow(
      //                     color: Colors.grey,
      //                     blurRadius: 5,
      //                     spreadRadius: 1,
      //                     offset: Offset(4, 4))
      //               ]),

      //           child: Column(
      //             children: [
      //               SimplePieChart.withSampleData()
      //               //SizedBox(height: 15,)
      //             ],
      //           // ),

      //     ),

      // )],
      ]),
    );
  }
}
