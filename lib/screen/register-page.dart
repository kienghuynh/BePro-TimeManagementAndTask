import 'package:bepro/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_auth/email_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/navigation_service.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromARGB(255, 221, 181, 73),
          Color.fromARGB(255, 99, 216, 204)
        ], begin: Alignment.topLeft, end: Alignment.bottomRight),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          //disable icon turn back in leading : flase
          automaticallyImplyLeading: true,
          leading: const BackButton(
            color: Color.fromARGB(255, 221, 181, 73),
          ),
          backgroundColor: Colors.white,
          title: const Text(
            'Register',
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
          padding: EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _image('assets/background-login.png', 220),
                const SizedBox(height: 0),
                _EmailField('Email...', emailController, Icon(Icons.mail)),
                const SizedBox(height: 15),
                _PasswordField('Password...', passwordController,
                    Icon(Icons.vpn_key_outlined)),
                const SizedBox(height: 15),
                _PasswordConfirmField(
                    'Confirm Password...',
                    confirmPasswordController,
                    passwordController,
                    Icon(Icons.vpn_key_rounded)),
                const SizedBox(height: 15),
                _FullNameField(
                  'Full name...',
                  fullNameController,
                  Icon(Icons.person_pin),
                ),
                const SizedBox(height: 15),
                _PhoneNumberField(
                  'Phone number...',
                  phoneController,
                  Icon(Icons.phone_android),
                ),
                const SizedBox(height: 15),
                _OTPField('OTP ...', otpController),
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

  Widget _registerButton() {
    return ElevatedButton(
      onPressed: () {
        SignUp(emailController.text, passwordController.text);
      },
      child: const SizedBox(
        width: double.infinity,
        child: Text(
          'Register',
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
        if (value!.isEmpty) return ('Please enter your password');
        if (!RegExp(r'^.{6,}$').hasMatch(value)) {
          return ('Please enter valid password. Min 6 character');
        }
        if (passwordController.text != controller.text) {
          return ("Confirm Password don't match with password");
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
        if (value!.isEmpty) return ('Please enter your full name');
        if (!RegExp(r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$")
            .hasMatch(value)) {
          return ('Please enter valid name');
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
      validator: (value) {
        if (value!.isEmpty) return ('Please enter your phone number');
        if (!RegExp(r'^0[1-9]{9}$').hasMatch(value)) {
          return ('Invalid phone number. 10 character, start with 0');
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
          child: Text('Send OTP'),
          onPressed: () {
            sendOTP();
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
      'Already have an account ?',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 16, color: Colors.white),
    );
  }

  Widget _signInTextButton() {
    return TextButton(
        child: Text('Sign in',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.white)),
        onPressed: () {
          NavigationService().goBack();
          debugPrint('clicked');
        });
  }

  void SignUp(String email, String password) async {
    if (_formKey.currentState!.validate() && verifyOTP()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postUserDetailsToFireStore()})
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

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());

    Fluttertoast.showToast(msg: "Account created successfully");

    NavigationService().popToFirst();
  }

  void sendOTP() async {
    EmailAuth.sessionName = "request send otp";
    var res = await EmailAuth.sendOtp(receiverMail: emailController.text);

    if (res) {
      Fluttertoast.showToast(msg: 'OTP sent');
    } else {
      Fluttertoast.showToast(msg: 'We could not send OTP right now');
    }
  }

  bool verifyOTP() {
    var res = EmailAuth.validate(
        receiverMail: emailController.text, userOTP: otpController.text);
    if (res) {
      Fluttertoast.showToast(msg: 'OTP verify');
      return true;
    } else {
      Fluttertoast.showToast(msg: 'Invalid OTP');
      return false;
    }
  }
}
