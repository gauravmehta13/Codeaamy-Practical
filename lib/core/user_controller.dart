import 'package:get/get.dart';

class UserData extends GetxController {
  String name = "";
  String email = "";
  String? img;

  updateUser(Map data) async {
    name = data["name"];
    email = data["email"];
    img = data["photo"];
    update();
  }
}
