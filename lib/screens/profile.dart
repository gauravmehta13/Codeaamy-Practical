import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/login.dart';
import '../core/models/user_data.dart';
import '../meta/Utility/constants.dart';

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
    //   try {
    //     UserData data = await ApiClient().getUserData();
    //     setState(() {
    //       userData = data;
    //       isLoading = false;
    //     });
    //     log(data.name ?? "");
    //     log(data.emailId ?? "");
    //     log(data.profilePic ?? "");
    //   } catch (e) {
    //     log(e.toString());
    //     displaySnackBar(e.toString(), context);
    //     setState(() => isLoading = false);
    //   }
  }

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
