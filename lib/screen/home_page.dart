import 'package:bepro/models/user_model.dart';
import 'package:bepro/screen/add_task_page.dart';
import 'package:bepro/services/navigation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromARGB(255, 221, 181, 73),
          Color.fromARGB(255, 99, 216, 204)
        ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        // image: DecorationImage(
        //   alignment: Alignment(0, -0.4),
        //   image: ExactAssetImage('assets/background-login.png'),
        // ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: Color.fromARGB(255, 221, 181, 73)),
          backgroundColor: Colors.white,
          title: const Text(
            'Welcome to BePro',
            style: TextStyle(color: Color.fromARGB(255, 221, 181, 73)),
          ),
          actions: [],
        ),
        body: _pageWidget(),
        drawer: _drawerMenu(),
        floatingActionButton: _btnAddFloating(),
      ),
    );
  }

  Widget _pageWidget() {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(left: 30, top: 50, right: 30),
          child: Form(
              key: _formKey,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _inboxButton(),
                          flex: 2,
                        ),
                        Expanded(child: SizedBox(), flex: 2),
                        Expanded(
                          child: _textCount(
                              "0", Color.fromARGB(255, 255, 138, 177)),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _bordertop(),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(child: _todayButton(), flex: 2),
                        Expanded(child: SizedBox(), flex: 2),
                        Expanded(
                          child: _textCount(
                              "0", Color.fromARGB(255, 255, 249, 136)),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _bordertop(),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(child: _upcomingButton(), flex: 3),
                        Expanded(child: SizedBox()),
                        Expanded(
                          child: _textCount(
                              "0", Color.fromARGB(255, 54, 255, 238)),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _bordertop(),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(child: _completedButton(), flex: 3),
                        Expanded(child: SizedBox()),
                        Expanded(
                          child: _textCount(
                              "0", Color.fromARGB(255, 67, 227, 123)),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget _drawerMenu() {
    return Drawer(
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [_headerDrawer(), _drawerList()],
          ),
        ),
      ),
    );
  }

  Widget _headerDrawer() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [
          Color.fromARGB(255, 221, 181, 73),
          Color.fromARGB(255, 99, 216, 204)
        ],
      )),
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.only(top: 5.0),
      child: Column(
        children: [
          SizedBox(
            height: 70,
          ),
          _image('assets/person.png', 50),
          _profileText("${loggedInUser.fullName}"),
          _profileText("${loggedInUser.email}"),
        ],
      ),
    );
  }

  Widget _drawerList() {
    return Container(
        padding: EdgeInsets.only(
          top: 15,
        ),
        child: Column(
            // shows the list of menu drawer
            children: [
              _createTextButtonDrawer(
                  'Change Infomation', Icon(Icons.recent_actors_outlined)),
              _createTextButtonDrawer(
                  'Change Password', Icon(Icons.settings_outlined)),
              _createTextButtonDrawer('Setting', Icon(Icons.settings_outlined)),
              _createTextButtonDrawer(
                  'Privacy policy', Icon(Icons.policy_outlined)),
              _createTextButtonDrawer(
                  'Send feedback', Icon(Icons.feedback_outlined)),
              Container(
                padding: EdgeInsets.all(25),
                child: _logoutButton(),
              ),
            ]));
  }

  Widget _createTextButtonDrawer(String text, Icon icon) {
    return TextButton.icon(
        icon: icon,
        label: Text('$text',
            textAlign: TextAlign.center,
            style:
                TextStyle(fontSize: 20, color: Color.fromARGB(255, 0, 0, 0))),
        onPressed: () {});
  }

  Widget _profileText(String string) {
    return Text(
      '$string',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 18, color: Colors.white),
    );
  }

  Widget _image(String url, double height) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          alignment: Alignment(0, -0.8),
          image: AssetImage('$url'),
        ),
      ),
      height: height,
    );
  }

  Widget _logoutButton() {
    return ElevatedButton(
      onPressed: () {
        logOut();
      },
      child: const SizedBox(
        width: double.infinity,
        child: Text(
          'Logout',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
      style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(side: BorderSide(color: Colors.black)),
          primary: Colors.white,
          onPrimary: Color.fromARGB(255, 78, 169, 160),
          padding: EdgeInsets.symmetric(vertical: 16)),
    );
  }

  Widget _inboxButton() {
    return TextButton.icon(
        icon: Icon(
          Icons.article_outlined,
          color: Color.fromARGB(255, 251, 169, 196),
          size: 24,
        ),
        label: Text(
          "Inbox",
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: 22,
            color: Color.fromARGB(255, 251, 169, 196),
          ),
        ),
        onPressed: () {});
  }

  Widget _todayButton() {
    return TextButton.icon(
        icon: Icon(
          Icons.light_mode_outlined,
          color: Color.fromARGB(255, 255, 249, 136),
          size: 24,
        ),
        label: Text(
          "Today",
          textAlign: TextAlign.right,
          style: TextStyle(
              fontSize: 22, color: Color.fromARGB(255, 255, 249, 136)),
        ),
        onPressed: () {});
  }

  Widget _upcomingButton() {
    return TextButton.icon(
        icon: Icon(
          Icons.calendar_month_outlined,
          color: Color.fromARGB(255, 54, 255, 238),
          size: 24,
        ),
        label: Text(
          "Upcoming",
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: 22,
            color: Color.fromARGB(255, 54, 255, 238),
          ),
        ),
        onPressed: () {});
  }

  Widget _completedButton() {
    return TextButton.icon(
        icon: Icon(
          Icons.assignment_turned_in_outlined,
          color: Color.fromARGB(255, 67, 227, 123),
          size: 24,
        ),
        label: Text(
          "Completed",
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: 22,
            color: Color.fromARGB(255, 67, 227, 123),
          ),
        ),
        onPressed: () {});
  }

  Widget _textCount(String text, Color color) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 22, color: color),
    );
  }

  Widget _bordertop() {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30),
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(color: Color.fromARGB(90, 0, 0, 0), width: 1))),
    );
  }

  Widget _btnAddFloating() {
    return Container(
      height: 70.0,
      width: 70.0,
      child: FittedBox(
        child: FloatingActionButton(
            onPressed: () {
              NavigationService().navigateToScreen(AddTaskPage());
            },
            backgroundColor: Color.fromARGB(255, 95, 255, 100),
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 35,
            )),
      ),
    );
  }

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
    NavigationService().popToFirst();
  }
}
