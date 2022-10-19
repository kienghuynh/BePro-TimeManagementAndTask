import 'package:bepro/models/user_model.dart';
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
        image: DecorationImage(
          alignment: Alignment(0, -0.4),
          image: ExactAssetImage('assets/background-login.png'),
        ),
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
      ),
    );
  }

  Widget _pageWidget() {
    return SingleChildScrollView(
      child: Column(children: [
      ]),
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
      style: TextStyle(
          fontSize: 18, color: Colors.white),
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

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
    NavigationService().popToFirst();
  }
}
