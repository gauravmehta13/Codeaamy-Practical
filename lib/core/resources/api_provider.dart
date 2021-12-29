import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:technource_practical/core/models/user_data.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) {
        // final isValidHost =
        //     ["192.168.1.67"].contains(host);
        //! Setting this to true will allow self signed certificates for all host
        //! Not Recommended

        return true;
      });
  }
}

class ApiClient {
  Future<UserData> getUserData() async {
    var response = await Dio().get("https://myjson.dit.upm.es/api/bins/gbt5");

    if (response.statusCode == 200) {
      log(response.data.toString());
      return UserData.fromJson(response.data["data"]);
    } else {
      throw Exception('Failed to load UserData');
    }
  }
}
