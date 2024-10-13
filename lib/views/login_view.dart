import 'package:flutter/material.dart';
import 'package:notes_app/services/local_storage_services.dart';
import 'package:notes_app/services/login_api_services.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  LocalStorageService localStorageService = LocalStorageService();
  bool isLogging = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final LoginApiServices loginApiServices = LoginApiServices();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //login to your account...
            Text(
              "Login to your account",
              style: TextStyle(
                fontSize: 23,
                color: Colors.grey[500],
              ),
            ),
            //Space..
            const SizedBox(
              height: 100,
            ),
            //Email Field
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                label: Text("Email"),
                border: OutlineInputBorder(),
              ),
            ),
            //Space..
            const SizedBox(
              height: 10,
            ),
            //Password Field
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                label: Text("Password"),
                border: OutlineInputBorder(),
              ),
            ),
            //Space
            const SizedBox(
              height: 13,
            ),
            //Login Button
            InkWell(
              onTap: () async {
                if (emailController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(
                      content: Text("Enter Email to log in"),
                    ),
                  );
                  return;
                }
                 if (passwordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(
                      content: Text("Enter Password to log in"),
                    ),
                  );
                  return;
                }
                setState(() {
                  isLogging = true;
                });
                await loginApiServices.login(
                    email: emailController.text,
                    password: passwordController.text,
                    context: context);
                setState(() {
                  isLogging = false;
                });
              },
              child: Container(
                width: double.infinity,
                height: screenHeight * 0.065,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Center(
                  child: isLogging
                      ? const SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3.5,
                          ),
                        )
                      : const Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
