import 'dart:convert';
import 'dart:developer';

import 'package:abda_learning/core/user_controller.dart';
import 'package:abda_learning/screens/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../meta/Utility/constants.dart';
import '../meta/Widgets/custom_button.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  bool obscureText = true;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: bgColor,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
        ),
        elevation: 0.0,
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: width * 0.06),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                Text("Create New Account".tr,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    )),
                box20,
                Text("Please fill in the form to continue".tr,
                    style: GoogleFonts.montserrat(
                      color: Colors.grey[600],
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    )),
                const Spacer(),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Enter your name'.tr : null,
                  controller: _nameController,
                  decoration: textfieldDecoration("Full Name".tr),
                ),
                box(height * 0.015),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email cannot be empty".tr;
                    } else if (!GetUtils.isEmail(value)) {
                      return "Please enter a valid email".tr;
                    }
                    return null;
                  },
                  decoration: textfieldDecoration("Email".tr),
                ),
                box(height * 0.015),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                  controller: _phoneController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Phone number cannot be empty".tr;
                    }
                    return null;
                  },
                  decoration: textfieldDecoration("Phone Number".tr),
                ),
                box(height * 0.015),
                TextFormField(
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).unfocus();
                    if (formKey.currentState!.validate()) {
                      emailSignUp();
                    }
                  },
                  controller: _passwordController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  obscureText: obscureText,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password cannot be empty".tr;
                    } else if (value.length < 6) {
                      return "Password must be atleast 6 characters".tr;
                    } else if (value.length > 20) {
                      return "Password must be less than 20 characters".tr;
                    }
                    return null;
                  },
                  decoration: textfieldDecoration("Password".tr,
                      suffixIcon: GestureDetector(
                          onTap: () =>
                              setState(() => obscureText = !obscureText),
                          child: Icon(
                              obscureText ? Icons.lock : Icons.lock_open,
                              size: 20,
                              color: Colors.grey[600]))),
                ),
                const Spacer(),
                CustomButton(
                    isLoading: isLoading,
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        emailSignUp();
                      }
                    },
                    text: "Sign Up".tr),
                box(height * 0.04),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Text.rich(
                    TextSpan(
                      style: GoogleFonts.montserrat(
                          color: Colors.grey[300],
                          fontWeight: FontWeight.w500,
                          fontSize: 12),
                      children: [
                        TextSpan(text: "Have an account?".tr),
                        TextSpan(text: " ".tr),
                        TextSpan(
                          text: 'Sign In'.tr,
                          style: const TextStyle(color: primaryColor),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future emailSignUp() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final email = _emailController.text;
    final password = _passwordController.text;
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    try {
      var authResult = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final User? user = authResult.user;
      if (user != null) {
        DocumentReference ref = users.doc(user.uid);
        ref.get().then((data) async {
          if (data.exists) {
            SharedPreferences pref = await SharedPreferences.getInstance();
            pref.setString("user", json.encode(data.data() as Map));
            Get.find<UserData>().updateUser(data.data() as Map);
            Get.offAll(() => const HomePage());
          } else {
            var userData = {
              'name': _nameController.text,
              'email': _emailController.text,
              "phone": _phoneController.text,
              "createdAt": DateTime.now().toUtc().toString()
            };
            ref.set(userData).then((value) async {
              SharedPreferences pref = await SharedPreferences.getInstance();
              pref.setString("user", json.encode(userData));
              Get.find<UserData>().updateUser(userData);
              Get.offAll(() => const HomePage());
            }).onError((error, d) {
              log("Failed to add user: $error");
              displaySnackBar("Failed to add user", context);
            });
          }
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint(e.toString());
      if (e.toString().contains("email-already-in-use")) {
        displaySnackBar("Email already in use".tr, context);
      } else if (e.toString().contains("network-request-failed")) {
        displaySnackBar("Network error".tr, context);
      } else {
        displaySnackBar("errorText".tr, context);
      }
    }
  }
}
