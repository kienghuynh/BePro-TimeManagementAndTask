import 'package:bepro/screen/home_page.dart';
import 'package:bepro/screen/register-page.dart';

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
            'Sign In',
            style: TextStyle(color: Color.fromARGB(255, 221, 181, 73)),
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
                const SizedBox(height: 250),
                _EmailField(
                    'Username...', emailController, const Icon(Icons.mail)),
                const SizedBox(height: 20),
                _PasswordField(
                    'Password', passwordController, const Icon(Icons.key)),
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


  Widget _EmailField(
      String hintText, TextEditingController controller, Icon icon) {
    var border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.black));

    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) return ('Please enter your email');
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value))
          return ('Please enter valid email');
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
        if (value!.isEmpty) return ('Please enter your password');
        if (!RegExp(r'^.{6,}$').hasMatch(value)) {
          return ('Please enter valid password. Min 6 character');
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
          'Sign in',
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
      'Welcome to BePro !',
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 34, color: Colors.white, fontWeight: FontWeight.bold),
    );
  }

  Widget _introduceText() {
    return const Text(
      'Organize your work and life.',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 22, color: Color.fromARGB(255, 50, 111, 105)),
    );
  }

  Widget _extraText() {
    return const Text(
      'Don\'t have User Account ?',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 0, 0, 0)),
    );
  }

  Widget _createTextButton() {
    return TextButton(
        child: Text('Create One',
            textAlign: TextAlign.center,
            style:
                TextStyle(fontSize: 20, color: Color.fromARGB(255, 0, 0, 0))),
        onPressed: () {
          NavigationService().navigateToScreen(RegisterPage());
        });
  }

  Widget _ForgetPassTextButton() {
    return TextButton(
        child: Text('Forget password ?',
            textAlign: TextAlign.center,
            style:
                TextStyle(fontSize: 16, color: Color.fromARGB(255, 0, 0, 0))),
        onPressed: () {
          //NavigationService().navigateToScreen(RegisterPage());
        });
  }

  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) => {
                  Fluttertoast.showToast(msg: "Login Successful"),
                  NavigationService().navigateToScreen(HomePage())
                });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
          errorMessage = "Your email address appears to be malformed.";

            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }
  
}
