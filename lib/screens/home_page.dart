import 'dart:developer';

import 'package:abda_learning/core/resources/api_provider.dart';
import 'package:abda_learning/meta/Utility/constants.dart';
import 'package:abda_learning/meta/models/students.dart';
import 'package:flutter/material.dart';

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
    try {
      var data = await ApiClient().getStudentsList();
      log('data:  ffffffffffffffffffffffffffffffffffffffffff');
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
    // getStudents();
    return Scaffold(
      body: Container(
          child: Container(
        child: Center(
          child: ElevatedButton(onPressed: getStudents, child: Text("data")),
        ),
      )),
    );
  }
}
