import 'package:bepro/pages/calendar_page.dart';
import 'package:bepro/pages/profile_page.dart';
import 'package:bepro/pages/task_page.dart.dart';
import 'package:bepro/pages/visualize_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _navigatorBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _pages = [TaskPage(),CalendarPage(),VisualizePage(), ProfilePage(),];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: _bottomBar(),
    );
  }

  Widget _bottomBar() {
    return Container(
      color: Color.fromARGB(255, 255, 255, 255),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: GNav(
            gap: 10,
            onTabChange: _navigatorBottomBar,
            tabBackgroundColor: Color.fromARGB(255, 99, 216, 204),
            color: Color.fromARGB(255, 99, 216, 204),
            activeColor: Color.fromARGB(255, 255, 255, 255),
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            tabActiveBorder:
                Border.all(color: Color.fromARGB(255, 99, 216, 204), width: 1),
            //curve: Curves.decelerate,
            hoverColor: Color.fromARGB(255, 255, 255, 255),
            duration: Duration(milliseconds: 500),
            padding: EdgeInsets.all(10),
            tabs: [
              GButton(
                icon: Icons.home_outlined,
                text: "Trang chủ",
                textStyle: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                iconSize: 24,
              ),
              GButton(
                icon: Icons.calendar_month_outlined ,
                text: "Lịch",
                textStyle: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                iconSize: 24,
              ),
              GButton(
                icon: Icons.assessment_outlined,
                text: "Thống kê",
                textStyle: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                iconSize: 24,
              ),
              GButton(
                icon: Icons.account_circle_outlined,
                text: "Cá nhân",
                textStyle: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                iconSize: 24,
              ),
              
            ]),
      ),
    );
  }
}
