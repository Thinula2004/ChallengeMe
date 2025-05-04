import 'package:challengeme/views/login.dart';
import 'package:challengeme/views/signup.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Challenge ME',
      debugShowCheckedModeBanner: false,
      home: const LoginView(),
      routes: {
        '/login': (context) => const LoginView(),
        '/signup': (context) => const SignupView(),
      },
    );
  }
}
