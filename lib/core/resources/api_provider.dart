import 'package:abda_learning/meta/models/students.dart';
import 'package:dio/dio.dart';

class ApiClient {
  Future<List<StudentData>> getStudentsList() async {
    var response = await Dio().get(
        "https://my-json-server.typicode.com/gauravmehta13/Codeaamy-Practical/Students");
    if (response.statusCode == 200) {
      List data = response.data;
      return data.map((i) => StudentData.fromJson(i)).toList();
    } else {
      return Future.error('Failed to load Students');
    }
  }
}
