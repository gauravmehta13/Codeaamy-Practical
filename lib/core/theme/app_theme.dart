import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:technource_practical/meta/Utility/constants.dart';

import 'app_color.dart';

//?https://medium.com/globant/flutter-dynamic-theme-dark-mode-custom-themes-bded572c8cdf

class AppTheme {
  final BuildContext context;
  AppTheme(this.context);
  get darkTheme => ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme.copyWith(
              bodyText1: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600, color: Colors.white)),
        ),
        appBarTheme: const AppBarTheme(
            color: AppColors.textBlack,
            systemOverlayStyle: SystemUiOverlayStyle.light),
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(color: AppColors.textGrey),
          labelStyle: TextStyle(color: AppColors.white),
        ),
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bgColor,
        canvasColor: AppColors.lightGreyDarkMode,
        primaryColor: primaryColor,
        // colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey)
        //     .copyWith(secondary: primaryColor),
      );

  get lightTheme => ThemeData(
        // textTheme: GoogleFonts.montserratTextTheme(
        //   Theme.of(context).textTheme.copyWith(
        //       bodyText1: GoogleFonts.montserrat(
        //           fontWeight: FontWeight.w600, color: Colors.black)),
        // ),
        primarySwatch: Colors.grey,
        appBarTheme: const AppBarTheme(
          brightness: Brightness.light,
          color: AppColors.grey2,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(color: AppColors.textGrey),
          labelStyle: TextStyle(color: AppColors.white),
        ),
        canvasColor: AppColors.white,
        brightness: Brightness.light,
        accentColor: AppColors.grey2,
        accentIconTheme: const IconThemeData(color: Colors.black),
      );
}
