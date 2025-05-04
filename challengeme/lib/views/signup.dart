import 'dart:convert';

import 'package:challengeme/components/button.dart';
import 'package:challengeme/components/input_field.dart';
import 'package:challengeme/services/auth_service.dart';
import 'package:challengeme/services/util.dart';
import 'package:flutter/material.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final TextEditingController nameTEC = TextEditingController();
  final TextEditingController emailTEC = TextEditingController();
  final TextEditingController passTEC = TextEditingController();
  final TextEditingController confirmPassTEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Center(
        child: Container(
          height: screenHeight * 0.8,
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
                'Welcome Newbie!',
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
                hint: 'Name',
                width: screenWidth * 0.85,
                hidden: true,
                tec: nameTEC,
              ),
              const SizedBox(height: 15),
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
              InputField(
                hint: 'Confirm Password',
                width: screenWidth * 0.85,
                hidden: true,
                tec: confirmPassTEC,
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
                    onPressed: () => navLogin(context),
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
                      'Already has an account ?',
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
                text: 'Signup',
                width: screenWidth * 0.85,
                callback: () => signUp(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navLogin(BuildContext context) {
    Navigator.pushNamed(context, '/login');
  }

  final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

  void signUp(BuildContext context) async {
    String name = nameTEC.text.trim();
    String email = emailTEC.text.trim();
    String password = passTEC.text.trim();
    String confPassword = confirmPassTEC.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      showWarning(context, 'Some fields are empty');
      return;
    } else if (!emailRegex.hasMatch(email)) {
      showWarning(context, 'Invalid email format');
      return;
    } else if (password.length < 4) {
      showWarning(context, 'Password is too short');
      return;
    } else if (password != confPassword) {
      showWarning(context, 'Confirmed Password and Password are not the same');
      return;
    }

    try {
      final response = await AuthService().signup(name, email, password);

      if (response.statusCode == 200) {
        showSuccess(context, 'Signup Successful !');
        Navigator.pushNamed(context, '/login');
      } else {
        final error = jsonDecode(response.body);
        print(response.body);
        showWarning(context, error['error'] ?? 'Signup failed');
      }
    } catch (e) {
      print('Error: $e');
      showWarning(context, 'Something went wrong. Try again');
    }
  }
}
