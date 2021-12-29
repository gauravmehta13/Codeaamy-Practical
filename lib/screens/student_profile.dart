import 'package:abda_learning/core/user_controller.dart';
import 'package:abda_learning/meta/Utility/constants.dart';
import 'package:abda_learning/meta/Widgets/logout_button.dart';
import 'package:abda_learning/meta/models/students.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentProfile extends StatefulWidget {
  final String address;
  final StudentData student;
  const StudentProfile({Key? key, required this.student, this.address = ""})
      : super(key: key);

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: bgColor,
      ),
      child: GetBuilder<UserData>(builder: (state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.all(30),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  box20,
                  CircleAvatar(
                    radius: width / 5,
                    backgroundColor: Colors.white70,
                    backgroundImage: AssetImage(
                        "assets/images/${widget.student.gender}.png"),
                  ),
                  SizedBox(height: height / 20),
                  Text(
                    "${widget.student.firstName}  ${widget.student.lastName}",
                    style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                  box10,
                  Text(
                    widget.student.email ?? "",
                    style: GoogleFonts.montserrat(
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                  ),
                  SizedBox(
                    height: height / 40,
                  ),
                  Text(
                    widget.address,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                        fontSize: 12),
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
                  const LogoutButton(),
                  box10,
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
