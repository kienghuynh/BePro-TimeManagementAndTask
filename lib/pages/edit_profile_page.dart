import 'package:bepro/models/user_model.dart';
import 'package:bepro/services/navigation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  var fullNameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;
  UserModel? loggedInUser = UserModel();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      isLoading = loggedInUser != null;
      fullNameController.text = loggedInUser?.fullName ?? "";
      phoneController.text = loggedInUser?.phoneNumber ?? "";
      emailController.text = loggedInUser?.email ?? "";
      passwordController.text = loggedInUser?.password ?? "";
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: const BackButton(
          color: Color.fromARGB(255, 99, 216, 204),
        ),
        title: const Text(
          'Sửa thông tin cá nhân',
          style: TextStyle(color: Color.fromARGB(255, 99, 216, 204)),
        ),
      ),
      body: isLoading
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Họ Tên:",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 99, 216, 204)),
                          ),
                          const SizedBox(height: 10),
                          AppGrayTextField(
                            controller: fullNameController,
                            hint: 'Họ Tên',
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if (value?.isEmpty ?? false) {
                                return "Vui lòng nhập họ tên";
                              }

                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "Di động:",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 99, 216, 204)),
                          ),
                          const SizedBox(height: 10),
                          AppGrayTextField(
                            keyboardType: TextInputType.phone,
                            controller: phoneController,
                            hint: 'Di động',
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if (value!.isEmpty)
                                return ('Vui lòng nhập số điện thoại.');
                              if (!RegExp(r'^0[1-9]{9}$').hasMatch(value)) {
                                return ('Dài 10 ký tự số và bắt đầu bằng 0');
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "Mật khẩu:",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 99, 216, 204)),
                          ),
                          const SizedBox(height: 10),
                          AppGrayTextField(
                            controller: passwordController,
                            hint: 'Mật khẩu',
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if (value?.isEmpty ?? false) {
                                return "Vui lòng nhập Mật khẩu";
                              }

                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "Email:",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 99, 216, 204)),
                          ),
                          const SizedBox(height: 10),
                          AppGrayTextField(
                            readOnly: true,
                            controller: emailController,
                            hint: '',
                            textInputAction: TextInputAction.done,
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          _editProfile()
                        ],
                      ),
                    ),
                  ))
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 99, 216, 204),
              ),
            ),
    );
  }

  Widget _editProfile() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          FirebaseFirestore.instance.collection("users").doc(user!.uid).update({
            'fullName': fullNameController.text.trim(),
            'phoneNumber': phoneController.text.trim(),
            'password': passwordController.text.trim(),
            'email': emailController.text.trim()
          }).then((value) {
            changPassword();
            NavigationService().goBack();
          }).catchError((error) => print("Có lỗi xảy ra $error"));
        }
      },
      style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(side: BorderSide(color: Colors.black)),
          primary: Colors.white,
          onPrimary: Color.fromARGB(255, 78, 169, 160),
          padding: EdgeInsets.symmetric(vertical: 16)),
      child: const SizedBox(
        width: double.infinity,
        child: Text(
          'Lưu',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  changPassword() async {
    try {
      await user?.updatePassword(passwordController.text);
    } catch (error) {
      Fluttertoast.showToast(
          toastLength: Toast.LENGTH_LONG, msg: error.toString());
    }
  }
}

class AppGrayTextField extends StatelessWidget {
  final String? hint;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final VoidCallback? onSuffixTap;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final bool readOnly;
  final int? maxLength;
  final Key? fieldKey;

  AppGrayTextField(
      {this.hint,
      this.fieldKey,
      this.controller,
      this.suffixIcon,
      this.onSuffixTap,
      this.maxLength,
      this.validator,
      this.obscureText = false,
      this.keyboardType,
      this.textInputAction,
      this.nextFocus,
      this.readOnly = false,
      this.focusNode});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: fieldKey,
      readOnly: readOnly,
      controller: controller,
      validator: validator,
      style: const TextStyle(color: Color(0xFF5E5E5E), fontSize: 14),
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLength: maxLength,
      textInputAction: textInputAction,
      focusNode: focusNode,
      onFieldSubmitted: (value) {
        if (nextFocus != null) {
          FocusScope.of(context).requestFocus(nextFocus);
        }
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFECECEC),
        focusColor: const Color(0xFFECECEC),
        hoverColor: const Color(0xFFECECEC),
        isDense: true,
        contentPadding: suffixIcon == null
            ? const EdgeInsets.symmetric(vertical: 20, horizontal: 23)
            : const EdgeInsets.only(top: 10, bottom: 10, left: 23),
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 14, color: Color(0xFFECECEC)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: Color(0xFFF6F6F6))),
        semanticCounterText: '',
        counterText: '',
        errorStyle: TextStyle(color: Theme.of(context).errorColor),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: Color(0xFFF6F6F6))),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: Color(0xFFF6F6F6))),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: Color(0xFFF6F6F6))),
      ),
    );
  }
}
