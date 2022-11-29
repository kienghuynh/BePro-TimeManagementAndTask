import 'package:bepro/pages/home_page.dart';
import 'package:bepro/pages/task_page.dart.dart';
import 'package:bepro/pages/register-page.dart';

import 'package:bepro/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;

  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: const BoxDecoration(
      //   gradient: LinearGradient(colors: [
      //     Color.fromARGB(255, 221, 181, 73),
      //     Color.fromARGB(255, 99, 216, 204)
      //   ],
      //   begin: Alignment.topLeft, end: Alignment.bottomRight),

      // ),
      child: Scaffold(
        //backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          // leading: const BackButton(
          //   color: Color.fromARGB(255, 221, 181, 73),
          // ),
          backgroundColor: Colors.white,
          title: Center(
            child: const Text(
              'Đăng nhập',
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
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _extraWelcomeText(),
                _image('assets/background-login.png', 300),
                _EmailField('Tài khoản Email ...', emailController,
                    const Icon(Icons.mail)),
                const SizedBox(height: 20),
                _PasswordField(
                    'Mật khẩu ...', passwordController, const Icon(Icons.key)),
                const SizedBox(height: 20),
                _loginButton(),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _extraText(),
                  ],
                ),
                _createTextButton(),
                _ForgetPassTextButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _image(String url, double height) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          alignment: Alignment(0, -0.8),
          image: ExactAssetImage('$url'),
        ),
      ),
      height: height,
    );
  }

  Widget _EmailField(
      String hintText, TextEditingController controller, Icon icon) {
    var border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.black));

    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) return ('Email không được trống');
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value))
          return ('Email chưa đúng định dạng.');
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
        if (value!.isEmpty) return ('Mật khẩu không được trống.');
        if (!RegExp(r'^.{6,}$').hasMatch(value)) {
          return ('Mật khẩu phải từ 6 ký tự.');
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

  Widget _loginButton() {
    return ElevatedButton(
      onPressed: () {
        signIn(emailController.text, passwordController.text);
      },
      child: const SizedBox(
        width: double.infinity,
        child: Text(
          'Đăng nhập',
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

  Widget _extraWelcomeText() {
    return const Text(
      'Chào mừng bạn đến với BePro !',
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 34,
          color: Color.fromARGB(255, 99, 216, 204),
          fontWeight: FontWeight.bold),
    );
  }

  Widget _extraText() {
    return const Text(
      'Bạn chưa có tài khoản ?',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 0, 0, 0)),
    );
  }

  Widget _createTextButton() {
    return TextButton(
        child: Text('Đăng ký',
            textAlign: TextAlign.center,
            style:
                TextStyle(fontSize: 20, color: Color.fromARGB(255, 0, 0, 0))),
        onPressed: () {
          NavigationService().navigateToScreen(RegisterPage());
        });
  }

  Widget _ForgetPassTextButton() {
    return TextButton(
        child: Text('Quên mật khẩu ?',
            textAlign: TextAlign.center,
            style:
                TextStyle(fontSize: 16, color: Color.fromARGB(255, 0, 0, 0))),
        onPressed: () {
          resetPassword(emailController.text);
        });
  }

  void resetPassword(String email) async {
    if (emailController.text == "") {
      Fluttertoast.showToast(toastLength: Toast.LENGTH_LONG,msg: 'vui lập nhập email khi tạo mới mật khẩu');
    } else {
      await _auth.sendPasswordResetEmail(email: email);
      Fluttertoast.showToast(
          toastLength: Toast.LENGTH_LONG,
          msg: 'vui lòng truy cập vào email trên trình duyệt để đổi mật khẩu');
    }
  }

  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) => {
                  Fluttertoast.showToast(msg: "Đăng nhập thành công !"),
                  NavigationService().replaceScreen(HomePage())
                });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Địa chỉ email của bạng không đúng định dạng.";

            break;
          case "wrong-password":
            errorMessage = "Sai tài khoản hoặc mật khẩu.";
            break;
          case "user-not-found":
            errorMessage = "Sai tài khoản hoặc mật khẩu..";
            break;
          case "user-disabled":
            errorMessage = "Tài khoản của bạn đã bị khoá.";
            break;
          case "too-many-requests":
            errorMessage = "Quá nhiều thao tác";
            break;
          case "operation-not-allowed":
            errorMessage = "Đăng nhập bằng email và mật khẩu đang gặp lỗi.";
            break;
          default:
            errorMessage = "Lỗi chưa xác định.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
      }
    }
  }
}
