import 'package:flutter/cupertino.dart';

class RegisterController {
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool verifyInput() {
    return (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        usernameController.text.isEmpty);
  }
}
