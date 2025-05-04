import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final String hint;
  final bool hidden;
  final TextEditingController tec;
  final double width;
  final double height;

  const InputField({
    Key? key,
    required this.hint,
    required this.hidden,
    required this.tec,
    this.width = 350,
    this.height = 55,
  }) : super(key: key);

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  final FocusNode _focusNode = FocusNode();
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4FF),
        border: Border.all(
          width: 1.6,
          color: isFocused ? const Color(0xFF1F41BB) : const Color(0x55AFBBE7),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: widget.tec,
        focusNode: _focusNode,
        textAlign: TextAlign.left,
        decoration: InputDecoration(
          hintText: widget.hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          hintStyle: const TextStyle(
            fontFamily: "Poppins_light",
            fontSize: 17,
            color: Color(0xFF626262),
          ),
        ),
        style: const TextStyle(
            fontFamily: "Poppins_bold",
            fontSize: 20,
            color: Color.fromARGB(255, 17, 47, 156),
            decoration: TextDecoration.none,
            fontWeight: FontWeight.w500),
        obscureText: widget.hidden,
        cursorColor: const Color(0xFF1F41BB),
      ),
    );
  }
}
