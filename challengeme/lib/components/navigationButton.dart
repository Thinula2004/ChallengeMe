import 'package:flutter/material.dart';

class NavigationButton extends StatelessWidget {
  final String imagePath;
  final String label;
  final String route;
  final double width;
  final double height;
  final double fontSize;

  const NavigationButton(
      {Key? key,
      required this.imagePath,
      required this.label,
      required this.route,
      this.fontSize = 15,
      this.width = 120,
      this.height = 120})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {Navigator.pushNamed(context, route)},
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color(0xFFDFDFDF),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontSize,
                fontFamily: "Poppins",
                color: const Color(0xFF000000),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
