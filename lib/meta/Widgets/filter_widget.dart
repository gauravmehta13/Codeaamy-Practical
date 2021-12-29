import 'package:abda_learning/meta/Utility/constants.dart';
import 'package:abda_learning/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

extension ParseToString on Gender {
  String toShortString() {
    return toString().split('.').last;
  }
}

class StudentFilter extends StatelessWidget {
  final Gender selectedGender;
  final int index;
  const StudentFilter(this.selectedGender, this.index, {Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Gender.values[index] == selectedGender
            ? primaryColor
            : Colors.transparent,
        borderRadius: BorderRadius.circular(
          25.0,
        ),
      ),
      child: Center(
        child: Text(Gender.values[index].toShortString().tr,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Gender.values[index] == selectedGender
                    ? Colors.white
                    : Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.w600)),
      ),
    );
  }
}
