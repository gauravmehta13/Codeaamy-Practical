import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../meta/Utility/constants.dart';
import '../meta/Utility/responsive.dart';
import '../meta/Widgets/custom_button.dart';
import '../screens/profile.dart';
import 'sign_up.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    bool isDesktop = Responsive.isDesktop(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: bgColor,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
        ),
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Form(
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
                  GestureDetector(
                    onTap: () {
                      showLangDialog(context, setState);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(
                            Icons.translate,
                            color: Colors.white,
                            size: 20,
                          ),
                          wbox5,
                          Text(languages[Get.locale!.languageCode],
                              style: GoogleFonts.montserrat(
                                  color: Colors.white, fontSize: 12))
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text("Welcome Back!".tr,
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      )),
                  box(height * 0.03),
                  Text("Please sign in to your account".tr,
                      style: GoogleFonts.montserrat(
                        color: Colors.grey[600],
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      )),
                  const Spacer(),
                  TextFormField(
                    controller: emailController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email cannot be empty".tr;
                      } else if (!GetUtils.isEmail(value)) {
                        return "Please enter a valid email".tr;
                      }
                      return null;
                    },
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: textfieldDecoration("Email".tr),
                  ),
                  box(height * 0.02),
                  TextFormField(
                    controller: passwordController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    obscureText: obscureText,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: textfieldDecoration("Password".tr,
                        suffixIcon: GestureDetector(
                            onTap: () =>
                                setState(() => obscureText = !obscureText),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Icon(
                                  obscureText ? Icons.lock : Icons.lock_open,
                                  size: 20,
                                  color: Colors.grey[600]),
                            ))),
                  ),
                  box(height * 0.02),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text("Forgot Password?".tr,
                        style: GoogleFonts.montserrat(
                          color: Colors.grey[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        )),
                  ),
                  const Spacer(),
                  CustomButton(
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          Map data = {
                            "email": emailController.text,
                            "password": passwordController.text,
                          };
                          prefs.setString("user", json.encode(data));
                          Get.offAll(() => const Profile());
                        }
                      },
                      text: "Sign In".tr),
                  box(height * 0.02),
                  InkWell(
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        Map data = {
                          "email": emailController.text,
                          "password": passwordController.text,
                        };
                        prefs.setString("user", json.encode(data));
                        Get.offAll(() => const Profile());
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 22),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                              "https://img.icons8.com/color/48/000000/google-logo.png",
                              height: 20),
                          wbox30,
                          Text("Sign in with Google".tr,
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              )),
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  box(height * 0.05),
                  GestureDetector(
                    onTap: () => Get.to(() => const SignUpPage()),
                    child: Text.rich(
                      TextSpan(
                        style: GoogleFonts.montserrat(
                            color: Colors.grey[300],
                            fontWeight: FontWeight.w500,
                            fontSize: 12),
                        children: [
                          TextSpan(text: "Don't have an account?".tr),
                          TextSpan(text: " ".tr),
                          TextSpan(
                            text: 'Sign Up'.tr,
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
      ),
    );
  }

  bool isLoading = false;

  Future googleLogin() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final googleSignIn = GoogleSignIn();
    setState(() {
      isLoading = true;
    });
    try {
      final user = await googleSignIn.signIn();
      if (user == null) {
        setState(() {
          isLoading = false;
        });
        return;
      } else {
        final googleAuth = await user.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await auth.signInWithCredential(credential).then((value) async {
          debugPrint("User is New = ${value.additionalUserInfo!.isNewUser}");
          Get.offAll(() => const Profile());
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint(e.toString());
      Get.snackbar("Error", "Error, please try again later..!!");
    }
  }
}
