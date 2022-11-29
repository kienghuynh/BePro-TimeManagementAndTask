import 'package:bepro/models/task_model.dart';
import 'package:bepro/models/user_model.dart';
import 'package:bepro/pages/edit_profile_page.dart';
import 'package:bepro/pages/login_page.dart';
import 'package:bepro/pages/task_page.dart.dart';
import 'package:bepro/services/navigation_service.dart';
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

  bool isLoading = false;
  @override
  void initState() {
    // FirebaseFirestore.instance
    //     .collection("users")
    //     .doc(user!.uid)
    //     .get()
    //     .then((value) {
    //   loggedInUser = UserModel.fromMap(value.data());
    //   setState(() {});
    // });
    getUser();

    super.initState();
  }

  Future<UserModel> getUser() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      isLoading = loggedInUser != null;
      setState(() {});
    });
    return loggedInUser;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Colors.white,
          title: const Center(
            child: Text(
              'Thông tin cá nhân',
              style: TextStyle(color: Color.fromARGB(255, 99, 216, 204)),
            ),
          ),
        ),
        body: isLoading
            ? _pageWidget()
            : const Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 99, 216, 204),
                ),
              ),
      ),
    );
  }

  Widget _pageWidget() {
    return FutureBuilder<UserModel>(
        future: getUser(),
        builder: (context, snapshot) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                _image('assets/person.png', 150),
                _editButton(),
                const Divider(
                  height: 0.5,
                ),
                const SizedBox(
                  height: 20,
                ),
                //_textInfo('${loggedInUser.fullName}'),
                LabelValue(
                  icon: Icons.account_circle,
                  value: loggedInUser.fullName,
                  label: "Tên",
                ),
                const SizedBox(height: 15),
                const Divider(
                  height: 0.5,
                ),
                const SizedBox(height: 10),
                LabelValue(
                  icon: Icons.call,
                  value: loggedInUser.phoneNumber,
                  label: "Di động",
                ),
                const SizedBox(height: 15),
                const Divider(
                  height: 0.5,
                ),
                const SizedBox(height: 10),
                LabelValue(
                  icon: Icons.email_outlined,
                  value: loggedInUser.email,
                  label: "Email",
                ),
                Container(
                  padding: EdgeInsets.all(25),
                  child: _logoutButton(),
                ),
              ],
            )),
          );
        });
  }

  void createPopUpLogout() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Container(
              width: 150,
              height: 50,
              child: Center(
                child: Text(
                  'Bạn có muốn đăng xuất ?',
                  style: TextStyle(fontSize: 21),
                ),
              ),
            ),
            actions: [
              TextButton.icon(
                  onPressed: () {
                    logOut();
                  },
                  icon: Icon(
                    Icons.delete_forever,
                    color: Colors.redAccent,
                    size: 30,
                  ),
                  label: Text('Có',
                      style: TextStyle(fontSize: 21, color: Colors.redAccent))),
              TextButton.icon(
                  onPressed: () {
                    NavigationService().goBack();
                  },
                  icon: Icon(
                    Icons.clear_outlined,
                    color: Colors.grey,
                    size: 30,
                  ),
                  label: Text(
                    'Không',
                    style: TextStyle(fontSize: 21, color: Colors.grey),
                  ))
            ],
          );
        });
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
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const EditProfilePage()));
        },
        icon: Icon(Icons.edit_outlined),
        label: Text(
          'Chỉnh sửa',
          style: TextStyle(fontSize: 20),
        ));
  }

  Widget _logoutButton() {
    return ElevatedButton(
      onPressed: () {
        createPopUpLogout();
      },
      child: const SizedBox(
        width: double.infinity,
        child: Text(
          'Đăng xuất',
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

  Widget _textInfo(String text) {
    return Container(
      child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(
              Icons.person,
              color: Color.fromARGB(255, 99, 216, 204),
            ),
            const SizedBox(
              width: 20,
            ),
            Text('${loggedInUser.fullName}')
          ])),
    );
  }
}

Future<void> logOut() async {
  await FirebaseAuth.instance.signOut();
  NavigationService().replaceScreen(LoginPage());
}

class LabelValue extends StatelessWidget {
  final String? value;
  final IconData icon;
  final String? label;

  const LabelValue({Key? key, this.value, required this.icon, this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 30,
            ),
            const SizedBox(width: 14),
            Expanded(
                child: Text(
              value ?? '',
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 99, 216, 204)),
            ))
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 38, top: 5),
          child: Text(
            label ?? '',
            style: const TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
      ],
    );
  }
}
