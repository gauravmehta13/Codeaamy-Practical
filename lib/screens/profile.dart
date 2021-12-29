import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:technource_practical/auth/login.dart';
import 'package:technource_practical/core/models/user_data.dart';
import 'package:technource_practical/core/resources/api_provider.dart';
import 'package:technource_practical/meta/Utility/constants.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  UserData? userData;
  bool isLoading = true;

  getUserData() async {
    try {
      UserData data = await ApiClient().getUserData();
      setState(() {
        userData = data;
        isLoading = false;
      });
      log(data.name ?? "");
      log(data.emailId ?? "");
      log(data.profilePic ?? "");
    } catch (e) {
      log(e.toString());
      displaySnackBar(e.toString(), context);
      setState(() => isLoading = false);
    }
  }

  List images = [
    "https://images.fandango.com/ImageRenderer/0/0/redesign/static/img/default_poster.png/0/images/masterrepository/other/ant_man_ver5.jpg",
    "https://cdn.shopify.com/s/files/1/0057/3728/3618/products/space-jam-a-new-legacy_hhwsqipd_240x360_crop_center.progressive.jpg?v=1618580955",
    "https://i.pinimg.com/originals/27/04/ee/2704ee6494308b58ba3968f17354596f.jpg",
  ];
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: bgColor,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                    color: primaryColor,
                  ))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      box20,
                      box30,
                      CircleAvatar(
                          radius: width / 5,
                          backgroundColor: Colors.white70,
                          backgroundImage: NetworkImage(userData?.profilePic ??
                              "https://i.imgur.com/ZY9jrQy.png")),
                      SizedBox(height: height / 20),
                      Text(
                        "Welcome".tr + " " "${userData?.name ?? "User"}",
                        style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      box10,
                      Text(
                        userData?.emailId ?? "NA",
                        style: GoogleFonts.montserrat(
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                            fontSize: 14),
                      ),
                      SizedBox(
                        height: height / 20,
                      ),
                      TextButton(
                          onPressed: () {
                            showLangDialog(context, setState);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.translate,
                                color: primaryColor,
                                size: 20,
                              ),
                              wbox5,
                              Text("Change Language".tr,
                                  style: GoogleFonts.montserrat(
                                      color: primaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                            ],
                          )),
                      const Spacer(),
                      TextButton(
                          onPressed: () {
                            SharedPreferences.getInstance().then((prefs) {
                              prefs.clear().then(
                                  (value) => Get.offAll(const LoginPage()));
                            });
                          },
                          child: Text("Logout".tr,
                              style: GoogleFonts.montserrat(
                                  color: Colors.redAccent,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600))),
                      box10,
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
