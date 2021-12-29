import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:technource_practical/screens/profile.dart';

import 'auth/getting_started.dart';
import 'core/localization/locale.dart';
import 'core/resources/api_provider.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  prefs.then((pref) async {
    String? userData = pref.getString("user");
    runApp(MyApp(
        pref: pref,
        page: userData == null ? const GettingStarted() : const Profile()));
  });
}

class MyApp extends StatelessWidget {
  final Widget? page;
  final SharedPreferences? pref;
  const MyApp({Key? key, this.page, this.pref}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        locale: LocalizationService.locale,
        fallbackLocale: LocalizationService.fallbackLocale,
        translations: LocalizationService(),
        title: 'Abda',
        debugShowCheckedModeBanner: false,
        onInit: () {
          if (pref != null) {
            String? language = pref!.getString('language');
            if (language != null) {
              Get.updateLocale(
                  Locale(language.split("-")[0], language.split("-")[1]));
            }
          }
        },
        theme: AppTheme(context).lightTheme,
        darkTheme: AppTheme(context).darkTheme,
        themeMode: ThemeMode.dark,
        defaultTransition: Transition.fadeIn,
        home: page);
  }
}
