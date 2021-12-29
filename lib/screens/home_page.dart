import 'dart:developer';

import 'package:abda_learning/core/resources/api_provider.dart';
import 'package:abda_learning/meta/Utility/constants.dart';
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

class _HomePageState extends State<HomePage> {
  List<StudentData> students = [];
  bool isLoading = false;

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
        title: const Text('Abda Learning'),
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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: primaryColor,
            ))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              physics: const BouncingScrollPhysics(),
              itemCount: students.length,
              itemBuilder: (context, index) {
                StudentData student = students[index];
                return Card(
                  child: Container(
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
                        backgroundImage:
                            AssetImage("assets/images/${student.gender}.png"),
                      ),
                      title: Text(
                        "${student.firstName}  ${student.lastName}",
                        style: GoogleFonts.montserrat(
                            fontSize: 14, fontWeight: FontWeight.w600),
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
                        Get.to(() =>
                            MapView(students: students, initialIndex: index));
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
