import 'dart:async';
import 'package:flutter/material.dart';
import 'package:notes_app/services/local_storage_services.dart';
import 'package:notes_app/views/home_view.dart';
import 'package:notes_app/views/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    navigateView();
  }

  Future<void> navigateView() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? result = prefs.getBool(LocalStorageService.loginStatusKey);
    Timer(const Duration(seconds: 1), () {
      if (result != null) {
        if (result == true) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeView(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginView(),
            ),
          );
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginView(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Notes",
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
      ),
    );
  }
}
