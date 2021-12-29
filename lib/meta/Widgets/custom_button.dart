import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Utility/constants.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final void Function() onTap;
  final bool isLoading;
  const CustomButton(
      {required this.onTap, this.text, this.isLoading = false, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        constraints: BoxConstraints(
          maxWidth: width * 0.9,
          maxHeight: height * 0.1,
        ),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(isLoading ? 500 : 20),
        ),
        padding: EdgeInsets.symmetric(
            horizontal: isLoading ? 12 : 20, vertical: isLoading ? 12 : 22),
        child: isLoading
            ? const SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(color: Colors.white),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(text ?? "Done",
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
      ),
    );
  }
}
