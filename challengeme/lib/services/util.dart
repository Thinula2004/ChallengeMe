import 'package:flutter/material.dart';

void showWarning(BuildContext context, String msg) {
  showSnackBar(context, msg, const Color(0xFFC74343));
}

void showSuccess(BuildContext context, String msg) {
  showSnackBar(context, msg, const Color(0xFF13AE82));
}

void showSnackBar(BuildContext context, String msg, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration: const Duration(seconds: 1, milliseconds: 30),
    content: Center(
      child: Text(
        msg,
        style: const TextStyle(
            fontSize: 15,
            fontFamily: "Poppins",
            letterSpacing: 2.0,
            fontWeight: FontWeight.w600),
      ),
    ),
    backgroundColor: color,
  ));
}
