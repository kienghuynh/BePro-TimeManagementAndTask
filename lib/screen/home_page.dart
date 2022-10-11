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
    // TODO: implement initState
    super.initState();

    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
          loggedInUser = UserModel.fromMap(value.data());
          setState(() {
        
          });
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
          leading: const BackButton(
            color: Color.fromARGB(255, 221, 181, 73),
          ),
          backgroundColor: Colors.white,
          title: const Text(
            'Welcome to BePro',
            style: TextStyle(color: Color.fromARGB(255, 221, 181, 73)),
          ),
        ),
        body: _pageWidget(),
      ),
    );
  }

  Widget _pageWidget() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text("${loggedInUser.fullName}"),
          _logoutButton(),
        ]
      ),
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
