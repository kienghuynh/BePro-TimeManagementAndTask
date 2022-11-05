import 'package:bepro/models/task_model.dart';
import 'package:bepro/models/user_model.dart';
import 'package:bepro/pages/task_page.dart.dart';
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
            _textInfo('${loggedInUser.fullName}'),
            SizedBox(
              height: 50,
            ),
            //_liskTask(),
            list2()
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
        label: Text(
          'Chỉnh sữa',
          style: TextStyle(fontSize: 17),
        ));
  }

  Widget _textInfo(String text) {
    return Container(
      child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.person,
                  color: Color.fromARGB(255, 99, 216, 204),
                )),
            Align(
                alignment: Alignment.center,
                child: Text('${loggedInUser.fullName}'))
          ])),
    );
  }

  Widget _liskTask() {
    CollectionReference tasks1 = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection("tasks");
    return Container(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          height: 500,
          width: 200,
          color: Colors.amber,
          child: FutureBuilder<DocumentSnapshot>(
            future: tasks1.doc("nslKdruk5egTm91OfQVz").get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text(
                    "Có lỗi xảy ra khi tải dữ liệu: \n ${snapshot.error.toString()}");
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Text('watting');
              } else if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                return Text("Full Name: ${data['title']}");
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget list2() {
    Stream<QuerySnapshot> _taskStream = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('tasks')
        .orderBy('startDate', descending: true)
        .snapshots();
    return Container(
      height: 300,
      width: 300,
      child: StreamBuilder<QuerySnapshot>(
        stream: _taskStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          } else {
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                // TaskModel item = TaskModel().fromJson(data);
                // debugPrint(item.toMap().toString());
                return ListTile(
                  title: Text(data['title']),
                  subtitle: Text(data['detail']),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }

  Stream<List<TaskModel>> getAllTask() {
    return firebaseFirestore
        .collection('users')
        .doc(user!.uid)
        .collection("tasks")
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TaskModel().fromJson(doc.data()))
            .toList());
  }
}
