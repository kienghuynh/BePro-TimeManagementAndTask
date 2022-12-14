import 'package:auth_email/auth_email.dart';
import 'package:bepro/Utility/utilities.dart';
import 'package:bepro/models/category_model.dart';
import 'package:bepro/models/user_model.dart';
import 'package:bepro/services/navigation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  final authEmail = AuthEmail(
    appName: 'Bepro Timemanagement And Task',
    server: 'https://auth.vursin.com/email/example',
    serverKey: 'ohYwh',
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   gradient: LinearGradient(colors: [
      //     Color.fromARGB(255, 221, 181, 73),
      //     Color.fromARGB(255, 99, 216, 204)
      //   ], begin: Alignment.topLeft, end: Alignment.bottomRight),
      // ),
      child: Scaffold(
        //backgroundColor: Colors.transparent,
        appBar: AppBar(
            //disable icon turn back in leading : flase
            //automaticallyImplyLeading: true,
            leading: const BackButton(
              color: Color.fromARGB(255, 99, 216, 204),
            ),
            backgroundColor: Colors.white,
            title: (const Text(
              '????ng k??',
              style: TextStyle(color: Color.fromARGB(255, 99, 216, 204)),
            ))),
        body: _pageWidget(),
      ),
    );
  }

  Widget _pageWidget() {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Utility().ImageWidget('assets/background-login.png', 220),
                const SizedBox(height: 0),
                _EmailField('Email...', emailController, Icon(Icons.mail)),
                const SizedBox(height: 15),
                _PasswordField('M???t kh???u...', passwordController,
                    Icon(Icons.vpn_key_outlined)),
                const SizedBox(height: 15),
                _PasswordConfirmField(
                    'X??c nh???n m???t kh???u...',
                    confirmPasswordController,
                    passwordController,
                    Icon(Icons.vpn_key_rounded)),
                const SizedBox(height: 15),
                _FullNameField(
                  'H??? v?? t??n...',
                  fullNameController,
                  Icon(Icons.person_pin),
                ),
                const SizedBox(height: 15),
                _PhoneNumberField(
                  'S??? ??i???n tho???i...',
                  phoneController,
                  Icon(Icons.phone_android),
                ),
                // const SizedBox(height: 15),
                // _OTPField('M?? OTP ...', otpController),
                const SizedBox(height: 50),
                _registerButton(),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _extraText(),
                    _signInTextButton(),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _registerButton() {
    return ElevatedButton(
      onPressed: () {
        SignUp(emailController.text, passwordController.text);
      },
      child: const SizedBox(
        width: double.infinity,
        child: Text(
          '????ng k??',
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

  Widget _EmailField(
      String hintText, TextEditingController controller, Icon icon) {
    var border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.black));

    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) return ('Email kh??ng ????? tr???ng.');
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value))
          return ('Email kh??ng h???p l???.');
        return null;
      },
      style: const TextStyle(color: Colors.black, fontSize: 18),
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: icon,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black),
        enabledBorder: border,
        focusedBorder: border,
        filled: true,
        fillColor: const Color.fromARGB(79, 236, 249, 247),
      ),
    );
  }

  Widget _PasswordField(
      String hintText, TextEditingController controller, Icon icon) {
    var border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.black));

    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) return ('M???t kh???u kh??ng ????? tr???ng.');
        if (!RegExp(r'^.{6,}$').hasMatch(value)) {
          return ('M???t kh???u t??? 6 k?? t???.');
        }
        return null;
      },
      style: const TextStyle(color: Colors.black, fontSize: 18),
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: icon,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black),
        enabledBorder: border,
        focusedBorder: border,
        filled: true,
        fillColor: const Color.fromARGB(79, 236, 249, 247),
      ),
      obscureText: true,
    );
  }

  Widget _PasswordConfirmField(
      String hintText,
      TextEditingController controller,
      TextEditingController passwordController,
      Icon icon) {
    var border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.black));

    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) return ('X??c nh???n m???t kh???u kh??ng ???????c tr???ng.');
        if (!RegExp(r'^.{6,}$').hasMatch(value)) {
          return ('X??c nh???n m???t kh???u ph???i t??? 6 k?? t???.');
        }
        if (passwordController.text != controller.text) {
          return ("X??c nh???n m???t kh???u ph???i tr??ng kh???p v???i m???t kh???u.");
        }
        return null;
      },
      style: const TextStyle(color: Colors.black, fontSize: 18),
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: icon,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black),
        enabledBorder: border,
        focusedBorder: border,
        filled: true,
        fillColor: const Color.fromARGB(79, 236, 249, 247),
      ),
      obscureText: true,
    );
  }

  Widget _FullNameField(
      String hintText, TextEditingController controller, Icon icon) {
    var border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.black));

    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) return ('Vui l??ng nh???p h??? v?? t??n');
        for (var i = 0; i < value.length; i++) {
          if (value[i].contains(RegExp(r'[0-9]')))
            return ('H??? v?? t??n kh??ng ch???a s??? ');
        }
        return null;
      },
      style: const TextStyle(color: Colors.black, fontSize: 18),
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: icon,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black),
        enabledBorder: border,
        focusedBorder: border,
        filled: true,
        fillColor: const Color.fromARGB(79, 236, 249, 247),
      ),
    );
  }

  Widget _PhoneNumberField(
      String hintText, TextEditingController controller, Icon icon) {
    var border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.black));

    return TextFormField(
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value!.isEmpty) return ('Vui l??ng nh???p s??? ??i???n tho???i.');
        if (!RegExp(r'^0[1-9]{9}$').hasMatch(value)) {
          return ('D??i 10 k?? t??? v?? b???t ?????u b???ng 0');
        }
        return null;
      },
      style: const TextStyle(color: Colors.black, fontSize: 18),
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: icon,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black),
        enabledBorder: border,
        focusedBorder: border,
        filled: true,
        fillColor: const Color.fromARGB(79, 236, 249, 247),
      ),
    );
  }

  Widget _OTPField(String hintText, TextEditingController controller) {
    var border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.black));

    return TextFormField(
      style: const TextStyle(color: Colors.black, fontSize: 18),
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: TextButton(
          child: Text('G???i m?? OTP'),
          onPressed: () {
            //sendOTP();
          },
        ),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black),
        enabledBorder: border,
        focusedBorder: border,
        filled: true,
        fillColor: const Color.fromARGB(79, 236, 249, 247),
      ),
    );
  }

  Widget _extraText() {
    return const Text(
      'B???n ???? c?? t??i kho???n ?',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 16, color: Colors.white),
    );
  }

  Widget _signInTextButton() {
    return TextButton(
        child: Text('????ng nh???p',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.white)),
        onPressed: () {
          NavigationService().goBack();
          //debugPrint('clicked');
        });
  }

  void SignUp(String email, String password) async {
    if (_formKey.currentState!.validate() /*&& verifyOTP()*/) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {
            postUserDetailsToFireStore()  
          })
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  postUserDetailsToFireStore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    UserModel userModel = UserModel();

    

    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.password = passwordController.text;
    userModel.fullName = fullNameController.text;
    userModel.phoneNumber = phoneController.text;

    CategoryModel cate = CategoryModel();
    var v1 = Uuid().v4();
    cate.uid = v1;
    cate.categoryName = 'C?? nh??n';

    await firebaseFirestore
    .collection("users")
    .doc(user.uid)
    .collection('categories')
    .doc(cate.uid)
    .set(cate.toMap());


    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());

    Fluttertoast.showToast(msg: "????ng k?? th??nh c??ng");

    NavigationService().popToFirst();
  }


  // void sendOTP() async {
  //   // var ramdom = Uuid().v1();
  //   var res = authEmail.sendOTP(email: emailController.text);

  //   if (await res) {
  //     Fluttertoast.showToast(msg: '???? g???i OTP');
  //   } else {
  //     Fluttertoast.showToast(msg: 'Ch??a th??? g???i OTP. Th??? l???i sau');
  //   }
  // }

  // bool verifyOTP() {
  //   var res = authEmail.verifyOTP(
  //       email: emailController.text, otp: otpController.text);
  //   if (res) {
  //     Fluttertoast.showToast(msg: '???? x??c th???c OTP');
  //     return true;
  //   } else {
  //     Fluttertoast.showToast(msg: 'OTP kh??ng h???p l???');
  //     return false;
  //   }
  // }
}
