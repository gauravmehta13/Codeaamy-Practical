import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

unFocusKeyboard(context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}

textfieldDecoration(label, {Widget? suffixIcon}) {
  return InputDecoration(
      suffixIcon: suffixIcon,
      isDense: true,
      filled: true,
      fillColor: const Color(0xff262a34),
      contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 22),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(18)),
        borderSide: BorderSide(width: 1, color: primaryColor),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(18)),
        borderSide: BorderSide(width: 1, color: bgColor),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(18)),
        borderSide: BorderSide(width: 1, color: Colors.red),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(18)),
        borderSide: BorderSide(width: 1, color: bgColor),
      ),
      hintText: label,
      hintStyle: GoogleFonts.montserrat(color: Colors.grey[600], fontSize: 12));
}

displaySnackBar(text, ctx, [time = 2]) {
  ScaffoldMessenger.of(ctx).showSnackBar(
    SnackBar(
      content: Text(text),
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: time),
    ),
  );
}

const EdgeInsets padding10 = EdgeInsets.all(10);
const SizedBox wbox5 = SizedBox(
  width: 5,
);
const SizedBox wbox10 = SizedBox(
  width: 10,
);
const SizedBox wbox20 = SizedBox(
  width: 20,
);
const SizedBox wbox30 = SizedBox(
  width: 30,
);
const SizedBox box5 = SizedBox(
  height: 5,
);
const SizedBox box10 = SizedBox(
  height: 10,
);
const SizedBox box20 = SizedBox(
  height: 20,
);
const SizedBox box30 = SizedBox(
  height: 30,
);

List languageList = [
  {
    "name": "English".tr,
    "imgUrl":
        "https://upload.wikimedia.org/wikipedia/en/thumb/a/ae/Flag_of_the_United_Kingdom.svg/1280px-Flag_of_the_United_Kingdom.svg.png",
    "langISO": "en",
    "countryISO": "US"
  },
  {
    "name": "Hindi".tr,
    "imgUrl":
        "https://upload.wikimedia.org/wikipedia/commons/thumb/4/41/Flag_of_India.svg/1280px-Flag_of_India.svg.png",
    "langISO": "hi",
    "countryISO": "IN"
  },
  {
    "name": "Français".tr,
    "imgUrl":
        "https://upload.wikimedia.org/wikipedia/en/thumb/c/c3/Flag_of_France.svg/2560px-Flag_of_France.svg.png",
    "langISO": "fr",
    "countryISO": "FR"
  },
  {
    "name": "Español".tr,
    "imgUrl":
        "https://upload.wikimedia.org/wikipedia/en/thumb/9/9a/Flag_of_Spain.svg/200px-Flag_of_Spain.svg.png",
    "langISO": "es",
    "countryISO": "ES"
  },
  {
    "name": "Arabic".tr,
    "imgUrl":
        "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Flag_of_Saudi_Arabia.svg/1280px-Flag_of_Saudi_Arabia.svg.png",
    "langISO": "ar",
    "countryISO": "SA"
  },
  {
    "name": "Mandarin".tr,
    "imgUrl":
        "https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Flag_of_the_People%27s_Republic_of_China.svg/1280px-Flag_of_the_People%27s_Republic_of_China.svg.png",
    "langISO": "zh",
    "countryISO": "CN"
  },
];

Map languages = {
  "en": "English",
  "hi": "हिंदी",
  "es": "Español",
  "fr": "Français",
  "ar": "العربية",
  "zh": "中文",
};
showLangDialog(BuildContext context, void Function(void Function()) setState,
    {bool isDesktop = false}) {
  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: Colors.white,
            child: SizedBox(
              width: isDesktop ? context.width / 2 : null,
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isDesktop ? 2 : 1, childAspectRatio: 4),
                  itemCount: languageList.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    var language = languageList[index];
                    return GestureDetector(
                      onTap: () async {
                        if (language["loading"] == "true") {
                          return;
                        }
                        if (language["langISO"] == "pt") {
                          Get.snackbar(
                            "Language not supported".tr,
                            "We are working on it".tr,
                            icon: const Icon(
                              Icons.error,
                              color: Colors.white,
                            ),
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            duration: const Duration(seconds: 2),
                          );
                          return;
                        }
                        try {
                          setState(() {
                            language["loading"] = "true";
                          });
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();

                          Get.updateLocale(Locale(
                            language["langISO"],
                            language["countryISO"],
                          ));
                          await prefs.setString(
                              "language",
                              language["langISO"] +
                                  "-" +
                                  language["countryISO"]);

                          setState(() {
                            language["loading"] = "false";
                          });
                          Get.back();
                        } catch (e) {
                          log(e.toString());
                          language["loading"] = "false";
                          Get.back();
                        }
                      },
                      child: Container(
                        height: 75,
                        padding: const EdgeInsets.all(17),
                        decoration: BoxDecoration(
                            color: Get.locale !=
                                    Locale(
                                      language["langISO"],
                                      language["countryISO"],
                                    )
                                ? Colors.grey.withOpacity(0.2)
                                : Colors.green.withOpacity(0.2),
                            border: Border.all(
                                color: const Color(0xFF4A7C7E50), width: 1),
                            borderRadius:
                                // index == 0
                                //     ? const BorderRadius.only(
                                //         topLeft: Radius.circular(20),
                                //         topRight: Radius.circular(20))
                                //     : index == languages.length - 1
                                //         ? const BorderRadius.only(
                                //             bottomLeft: Radius.circular(20),
                                //             bottomRight: Radius.circular(20)):
                                const BorderRadius.all(
                              Radius.circular(0),
                            )),
                        child: Row(
                          children: [
                            Image.network(language["imgUrl"],
                                width: 32, height: 21),
                            const SizedBox(width: 14),
                            Text(
                              language["name"],
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15),
                            ),
                            const Spacer(),
                            Get.locale ==
                                    Locale(
                                      language["langISO"],
                                      language["countryISO"],
                                    )
                                ? Image.network(
                                    'https://cdn-icons-png.flaticon.com/128/190/190411.png',
                                    width: 22,
                                    height: 22)
                                : language["loading"] == "true"
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ))
                                    : Container(),
                            const SizedBox(width: 2),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          );
        },
      );
    },
  );
}

SizedBox box(double h) => SizedBox(
      height: h,
    );

SizedBox wbox(double w) => SizedBox(
      width: w,
    );

const primaryColor = Color(0xFF5468ff);
const secondaryColor = Color(0xFF2A2D3E);
const bgColor = Color(0xFF181a20);
