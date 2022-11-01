import 'package:bepro/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
            '',
            style: TextStyle(color: Color.fromARGB(255, 221, 181, 73)),
          ),
        ),
        body: _pageWidget(),
      ),
    );
  }

  Widget _pageWidget() {
    return Container(
      child: SingleChildScrollView(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
            ),
            _image('assets/person.png', 150),
            _editButton(),
            _textInfo('${loggedInUser.fullName}')
          ],
        ),
      )),
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

  Widget _editButton() {
    return TextButton.icon(
        onPressed: () {},
        icon: Icon(Icons.edit_outlined),
        label: Text('Chỉnh sữa',
          style: TextStyle(
            fontSize: 17
          ),));
  }

  Widget _textInfo(String text) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(10), 
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[ 
            Align(
              alignment: Alignment.center,
              child: Icon(Icons.person,
                color: Color.fromARGB(255, 99, 216, 204),)),
            Align(
              alignment: Alignment.center,
              child: Text('${loggedInUser.fullName}'))
          ])),
    );
  }
}
