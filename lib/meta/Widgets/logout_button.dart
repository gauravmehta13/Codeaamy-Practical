import 'package:abda_learning/auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          FirebaseAuth.instance
              .signOut()
              .then((value) => SharedPreferences.getInstance().then((prefs) {
                    prefs
                        .clear()
                        .then((value) => Get.offAll(const LoginPage()));
                  }));
        },
        child: Text("Logout".tr,
            style: GoogleFonts.montserrat(
                color: Colors.redAccent,
                fontSize: 14,
                fontWeight: FontWeight.w600)));
  }
}
