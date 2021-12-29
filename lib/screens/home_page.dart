import 'dart:developer';

import 'package:abda_learning/core/resources/api_provider.dart';
import 'package:abda_learning/meta/Utility/constants.dart';
import 'package:abda_learning/meta/Utility/responsive.dart';
import 'package:abda_learning/meta/Widgets/filter_widget.dart';
import 'package:abda_learning/meta/models/students.dart';
import 'package:abda_learning/screens/map_view.dart';
import 'package:abda_learning/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

enum Gender { All, Male, Female }

class _HomePageState extends State<HomePage> {
  List<StudentData> students = [];
  bool isLoading = false;
  Gender selectedGender = Gender.All;

  @override
  void initState() {
    getStudents();
    super.initState();
  }

  getStudents() async {
    setState(() {
      isLoading = true;
    });
    try {
      var data = await ApiClient().getStudentsList();
      setState(() {
        students = data;

        isLoading = false;
      });
      log(data[0].toJson().toString());
    } catch (e) {
      log(e.toString());
      displaySnackBar(e.toString(), context);
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: bgColor,
        elevation: 0,
        title: Text.rich(
          TextSpan(
            style: GoogleFonts.montserrat(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 30),
            children: [
              TextSpan(text: 'abda'.tr),
              const TextSpan(
                text: '.',
                style: TextStyle(color: primaryColor),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_sharp),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Profile(),
                ),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: primaryColor,
            ))
          : Column(
              children: [
                Container(
                  color: bgColor,
                  padding: Responsive.isMobile(context)
                      ? EdgeInsets.zero
                      : EdgeInsets.symmetric(horizontal: context.width / 4),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(
                        25.0,
                      ),
                    ),
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, childAspectRatio: 4),
                      shrinkWrap: true,
                      itemCount: Gender.values.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedGender = Gender.values[index];
                            });
                          },
                          child: StudentFilter(selectedGender, index),
                        );
                      },
                    ),
                  ),
                ),
                students.isEmpty
                    ? const Expanded(
                        child: Center(
                          child: Text(
                            "No Students Available",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey),
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          physics: const BouncingScrollPhysics(),
                          itemCount: students.length,
                          itemBuilder: (context, index) {
                            StudentData student = students[index];
                            if (selectedGender.toShortString() ==
                                    student.gender ||
                                selectedGender.toShortString() == "All") {
                              return StudentTile(
                                  student: student, students: students);
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
              ],
            ),
      floatingActionButton: isLoading
          ? null
          : FloatingActionButton(
              backgroundColor: primaryColor,
              onPressed: () {},
              child: IconButton(
                icon: const Icon(
                  Icons.map,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapView(students: students),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class StudentTile extends StatelessWidget {
  const StudentTile({
    Key? key,
    required this.student,
    required this.students,
  }) : super(key: key);

  final StudentData student;
  final List<StudentData> students;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.hardEdge,
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.black),
        ),
        tileColor: Colors.white,
        leading: CircleAvatar(
          backgroundColor: primaryColor,
          backgroundImage: AssetImage("assets/images/${student.gender}.png"),
        ),
        title: Text(
          "${student.firstName}  ${student.lastName}",
          style:
              GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          student.email ?? "",
          style: GoogleFonts.montserrat(fontSize: 12),
        ),
        trailing: const Icon(
          Icons.keyboard_arrow_right,
          color: primaryColor,
        ),
        onTap: () {
          Get.to(() => MapView(
              students: students, initialIndex: students.indexOf(student)));
        },
      ),
    );
  }
}
