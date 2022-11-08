import 'package:bepro/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';

class AllTaskPage extends StatefulWidget {
  const AllTaskPage({super.key});

  @override
  State<AllTaskPage> createState() => _AllTaskPageState();
}

class _AllTaskPageState extends State<AllTaskPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  final _formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  


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
              'Tất cả công việc',
              style: TextStyle(color: Color.fromARGB(255, 221, 181, 73)),
            ),
          ),
          body: _pageWidget(),
        ));
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
            list()
          ],
        ),
      )),
    );
  }

  Widget list() {
    Stream<QuerySnapshot> _taskStream = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('tasks')
        .orderBy('startDate', descending: true)
        .snapshots();
    return SingleChildScrollView(
      child: Container(
        height: 600,
        width: 370,
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
                  return Container(
                    margin: EdgeInsets.all(2),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(18)),
                    child: ListTile(
                      leading: IconButton(icon: Icon(Icons.check_circle_outline_outlined, color: Color.fromARGB(255, 105, 240, 132),), onPressed: (){},),
                      title: Row(
                        children:[ Text(
                          data['title'],
                          style: TextStyle(fontSize: 22),
                        ),
                        
                      ]),
                      subtitle: Column(children: [
                        Row(children: [
                          Text(data['detail'],style: TextStyle(fontSize: 17, color: Color.fromARGB(195, 0, 0, 0)),),
                          Expanded(flex: 2,child: Text(''),),
                          (data['isImportant'])
                              ? IconButton(icon: Icon(Icons.star ),color: Colors.amber,onPressed:() {},)
                              : IconButton(icon: Icon(Icons.star_border ),color: Colors.amber,onPressed:() {},)
                        ]),
                        Row(children: [
                          Text('Từ: ${data['startDate']} tới: ${data['endDate']}', style: TextStyle(color: Colors.redAccent),),
                         
                          ],
                        )
                      ]),
                    ),
                  );
                }).toList(),
              );
            }
          },
        ),
      ),
    );
  }
}
