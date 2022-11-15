import 'package:bepro/models/task_model.dart';
import 'package:bepro/models/user_model.dart';
import 'package:bepro/pages/task_page.dart.dart';
import 'package:bepro/widget/utilities.dart';
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
  final User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  final _formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Colors.white,
          title: Center(
              child: const Text(
              'Thông tin cá nhân',
              style: TextStyle(color: Color.fromARGB(255, 99, 216, 204)),
            ),
            ),
        ),
        body: _pageWidget(),
      ),
    );
  }

  Widget _pageWidget() {
    return SingleChildScrollView(
      child: Container(
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
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 80,
            ),
            _image(150,150),
            SizedBox(height: 20,),
            _textInfoName('${loggedInUser.fullName}','Họ và tên', 18, Icons.person),
            SizedBox(
              height: 5,
            ),
            Container(
              margin: EdgeInsets.only(left:30),
              child: Utility().BottomLine()),
            SizedBox(height: 20,),
            _textInfo('${loggedInUser.email}','Email:', 18, Icons.email_outlined),
            SizedBox(height: 5,),
            Container(
              margin: EdgeInsets.only(left:30),
              child: Utility().BottomLine()),
            SizedBox(height: 30,),
            _textInfoName('${loggedInUser.phoneNumber}','Số điện thoại', 18, Icons.phone),
            SizedBox(height: 50,),
            
          ],
        ),
      )),
    );
  }

  Widget _image( double height, double size) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.person, size: size,),
      height: height,
    );
  }

  Widget _editButton() {
    return TextButton.icon(
        onPressed: () {},
        icon: Icon(Icons.edit_outlined),
        label: Text(
          'Chỉnh sữa',
          style: TextStyle(fontSize: 17),
        ));
  }

  Widget _textInfo(String text, String textTitle,double fontSize, IconData icon) {
    return Container(
      width: 350,
      height: 90,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 19),
                child: Icon(icon,size: fontSize+6,)),
              Container(
                margin: EdgeInsets.only(left: 15),
                child: Text(textTitle, style: TextStyle(fontSize: fontSize),),),
              Container(child: SizedBox(),)
            
          ],
              
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              
              Container(
                margin: EdgeInsets.all(15),
                child: Text(text, style: TextStyle(fontSize: fontSize),)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _textInfoName(String text, String textTitle,double fontSize, IconData icon) {
    return Container(
      width: 350,
      height: 40,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Icon(icon,size: fontSize+6,)),
              Expanded(flex: 2,child: Text(textTitle, style: TextStyle(fontSize: fontSize),)),
              Expanded(flex: 3,child: Text(text, style: TextStyle(fontSize: fontSize),))]
          ),
        ],
      ),
    );
  }

}
