import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Translations/ar_sa.dart';
import 'Translations/en_us.dart';
import 'Translations/es_es.dart';
import 'Translations/fr_fr.dart';
import 'Translations/hi_in.dart';
import 'Translations/zh_cn.dart';

class LocalizationService extends Translations {
  // Default locale
  static const locale = Locale('en', 'US');

  // fallbackLocale saves the day when the locale gets in trouble
  static const fallbackLocale = Locale('en', 'US');

  // Supported locales
  // Needs to be same order with langs

  static const locales = [
    Locale('en', 'US'),
    Locale('hi', 'IN'),
    Locale('ru', 'RU'),
    Locale('es', 'ES'),
    Locale('fr', 'FR'),
    Locale('ar', 'AR'),
    Locale('zh', 'CN'),
  ];

  // Keys and their translations
  // Translations are separated maps in `lang` file
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUS,
        'hi_IN': hiIN,
        'es_ES': esES,
        'fr_FR': frFR,
        'ar_SA': arSA,
        'zh_CN': zhCN,
      };
}
