import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../meta/Utility/constants.dart';
import '../meta/Widgets/custom_button.dart';
import '../screens/profile.dart';

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
  bool obscureText = true;
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                  controller: _phoneController,
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
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        Map data = {
                          "email": _emailController.text,
                          "password": _passwordController.text,
                          "name": _nameController.text,
                          "phone": _phoneController.text
                        };
                        prefs.setString("user", json.encode(data));
                        Get.offAll(() => const Profile());
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
                          style: TextStyle(color: primaryColor),
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
}
