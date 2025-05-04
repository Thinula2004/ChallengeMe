import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final VoidCallback callback;

  const Button({
    Key? key,
    required this.text,
    required this.callback,
    this.width = 350,
    this.height = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: callback,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(const Color(0xFF1F41BB)),
          side: MaterialStateProperty.all(BorderSide.none),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide.none,
            ),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 18,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
