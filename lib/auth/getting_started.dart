import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../meta/Utility/constants.dart';
import '../meta/Widgets/custom_button.dart';
import 'login.dart';

class GettingStarted extends StatefulWidget {
  const GettingStarted({Key? key}) : super(key: key);

  @override
  _GettingStartedState createState() => _GettingStartedState();
}

class _GettingStartedState extends State<GettingStarted> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Color(0xFFe5edf1),
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          SizedBox(
            height: context.height,
            width: context.width,
            child: Image.asset(
              "assets/images/loginBG.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: context.height,
            width: context.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Colors.transparent,
                  bgColor.withOpacity(0.7),
                  bgColor
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 5,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width / 8, vertical: 10),
                    child: Column(
                      children: [
                        Text.rich(
                          TextSpan(
                            style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 35),
                            children: [
                              TextSpan(text: 'abda'.tr),
                              TextSpan(
                                text: '.',
                                style: TextStyle(color: primaryColor),
                              ),
                            ],
                          ),
                        ),
                        box30,
                        Text(
                            "Get connected with Students all over the world, and start your journey to become a part of the community."
                                .tr,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12)),
                      ],
                    ),
                  ),
                  box(height * 0.04),
                  loginButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget loginButton() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: CustomButton(
          onTap: () => Get.to(() => const LoginPage()),
          text: "Get Started".tr,
        ));
  }
}
