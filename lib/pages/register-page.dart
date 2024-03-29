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
              'Đăng ký',
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
                _PasswordField('Mật khẩu...', passwordController,
                    Icon(Icons.vpn_key_outlined)),
                const SizedBox(height: 15),
                _PasswordConfirmField(
                    'Xác nhận mật khẩu...',
                    confirmPasswordController,
                    passwordController,
                    Icon(Icons.vpn_key_rounded)),
                const SizedBox(height: 15),
                _FullNameField(
                  'Họ và tên...',
                  fullNameController,
                  Icon(Icons.person_pin),
                ),
                const SizedBox(height: 15),
                _PhoneNumberField(
                  'Số điện thoại...',
                  phoneController,
                  Icon(Icons.phone_android),
                ),
                // const SizedBox(height: 15),
                // _OTPField('Mã OTP ...', otpController),
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
          'Đăng ký',
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
        if (value!.isEmpty) return ('Email không để trống.');
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value))
          return ('Email không hợp lệ.');
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
        if (value!.isEmpty) return ('Mật khẩu không để trống.');
        if (!RegExp(r'^.{6,}$').hasMatch(value)) {
          return ('Mật khẩu từ 6 ký tự.');
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
        if (value!.isEmpty) return ('Xác nhận mật khẩu không được trống.');
        if (!RegExp(r'^.{6,}$').hasMatch(value)) {
          return ('Xác nhận mật khẩu phải từ 6 ký tự.');
        }
        if (passwordController.text != controller.text) {
          return ("Xác nhận mật khẩu phải trùng khợp với mật khẩu.");
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
        if (value!.isEmpty) return ('Vui lòng nhập họ và tên');
        for (var i = 0; i < value.length; i++) {
          if (value[i].contains(RegExp(r'[0-9]')))
            return ('Họ và tên không chứa số ');
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
        if (value!.isEmpty) return ('Vui lòng nhập số điện thoại.');
        if (!RegExp(r'^0[1-9]{9}$').hasMatch(value)) {
          return ('Dài 10 ký tự và bắt đầu bằng 0');
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
          child: Text('Gữi mã OTP'),
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
      'Bạn đã có tài khoản ?',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 16, color: Colors.white),
    );
  }

  Widget _signInTextButton() {
    return TextButton(
        child: Text('Đăng nhập',
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
    cate.categoryName = 'Cá nhân';

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

    Fluttertoast.showToast(msg: "Đăng ký thành công");

    NavigationService().popToFirst();
  }


  // void sendOTP() async {
  //   // var ramdom = Uuid().v1();
  //   var res = authEmail.sendOTP(email: emailController.text);

  //   if (await res) {
  //     Fluttertoast.showToast(msg: 'Đã gửi OTP');
  //   } else {
  //     Fluttertoast.showToast(msg: 'Chưa thể gửi OTP. Thử lại sau');
  //   }
  // }

  // bool verifyOTP() {
  //   var res = authEmail.verifyOTP(
  //       email: emailController.text, otp: otpController.text);
  //   if (res) {
  //     Fluttertoast.showToast(msg: 'Đã xác thực OTP');
  //     return true;
  //   } else {
  //     Fluttertoast.showToast(msg: 'OTP không hợp lệ');
  //     return false;
  //   }
  // }
}
