import 'package:flutter/material.dart';

TextStyle title01 = TextStyle(
    color: Color(0xFF555555), fontSize: 35, fontWeight: FontWeight.bold);

TextStyle title02 =
    TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold);

TextStyle title03 = TextStyle(
    color: Color(0xFF555555), fontSize: 22, fontWeight: FontWeight.bold);

TextStyle title04 = TextStyle(
    color: Color(0xFFE86060), fontSize: 16, fontWeight: FontWeight.bold);

TextStyle title05 = TextStyle(
    color: Color(0xFF000000), fontSize: 16, fontWeight: FontWeight.bold);

TextStyle title06 = TextStyle(
    color: Color.fromARGB(255, 95, 93, 93),
    fontSize: 16,
    fontWeight: FontWeight.bold);

TextStyle title07(double size) {
  return TextStyle(color: Colors.black, fontSize: size);
}

TextStyle title08(double size) {
  return TextStyle(
      color: Color(0xFFFFFFFF), fontSize: size, fontWeight: FontWeight.bold);
}

TextStyle title09(double size) {
  return TextStyle(
      color: Color(0xFF000000), fontSize: size, fontWeight: FontWeight.bold);
}

TextStyle title10(double size) {
  return TextStyle(
      color: Color(0xFF555555), fontSize: size, fontWeight: FontWeight.bold);
}

InputDecoration input01(String hint) {
  return InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: const Color(0xFFF1F4FF),
    contentPadding: const EdgeInsets.all(15),
    hintStyle: const TextStyle(
      fontFamily: "Poppins_light",
      fontSize: 17,
      color: Color(0xFF626262),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(
        width: 1.6,
        color: Color(0x55AFBBE7),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(
        width: 1.6,
        color: Color(0xFF1F41BB),
      ),
    ),
  );
}
