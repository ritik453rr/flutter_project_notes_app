import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notes_app/res/app_url.dart';
import 'package:notes_app/services/local_storage_services.dart';
import 'package:notes_app/views/home_view.dart';

class LoginApiServices {
  LocalStorageService localStorageService = LocalStorageService();

  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    final body = {"email": email, "password": password};
    try {
      final response = await http.post(
        Uri.parse(AppUrl.loginUrl),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        localStorageService.setLoginStatus(status: true);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeView(),
          ),
        );
      } else {
        showErrorMessage(context: context, msg: "Invalid email or password");
      }
    } catch (e) {
      showErrorMessage(
        context: context,
        msg: "An unexpected error occurred. Please try again.",
      );
    }
  }

  void showErrorMessage({required BuildContext context, required String msg}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }
}
