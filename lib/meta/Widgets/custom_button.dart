import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:technource_practical/meta/Utility/constants.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final void Function() onTap;
  const CustomButton({required this.onTap, this.text, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
        child: Center(
            child: Text(text ?? "Done",
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ))),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
