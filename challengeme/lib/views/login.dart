import 'package:challengeme/components/button.dart';
import 'package:challengeme/components/input_field.dart';
import 'package:challengeme/services/auth_service.dart';
import 'package:challengeme/services/util.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginState();
}

class _LoginState extends State<LoginView> {
  final TextEditingController emailTEC = TextEditingController();
  final TextEditingController passTEC = TextEditingController();
  // final apiService = APIService();
  // final dbService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Center(
        child: Container(
          height: screenHeight * 0.7,
          child: Column(
            children: [
              const Text(
                'Challenge ME',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF1F41BB),
                  fontSize: 30,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Welcome back you\'ve been \nmissed!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 17,
                  letterSpacing: 2,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 60),
              InputField(
                hint: 'Email',
                width: screenWidth * 0.85,
                hidden: false,
                tec: emailTEC,
              ),
              const SizedBox(height: 15),
              InputField(
                hint: 'Password',
                width: screenWidth * 0.85,
                hidden: true,
                tec: passTEC,
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                width: screenWidth * 0.85,
                alignment: Alignment.centerRight,
                child: MouseRegion(
                  onEnter: (_) => SystemMouseCursors.click,
                  onExit: (_) => SystemMouseCursors.basic,
                  child: ElevatedButton(
                    onPressed: () => navSignup(context),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                      side: MaterialStateProperty.all(BorderSide.none),
                      elevation: MaterialStateProperty.all(0),
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                    ),
                    child: const Text(
                      'New Here ?',
                      style: TextStyle(
                        color: Color(0xFF1F41BB),
                        fontSize: 13,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Button(
                text: 'Login',
                width: screenWidth * 0.85,
                callback: () => login(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navSignup(BuildContext context) {
    Navigator.pushNamed(context, '/signup');
  }

  void login(BuildContext context) async {
    String email = emailTEC.text.trim();
    String password = passTEC.text.trim();

    if (email.isEmpty) {
      showWarning(context, 'Email is empty');
      return;
    } else if (password.isEmpty) {
      showWarning(context, 'Password is empty');
      return;
    }

    try {
      final response = await AuthService().login(email, password);

      if (response.statusCode == 200) {
        showSuccess(context, 'Login Successful !');
      } else {
        final error = jsonDecode(response.body);
        showWarning(context, error['error'] ?? 'Login failed');
      }
    } catch (e) {
      print('Error: $e');
      showWarning(context, 'Something went wrong. Try again');
    }
  }
}
