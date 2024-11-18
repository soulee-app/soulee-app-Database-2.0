import 'package:flutter/material.dart';

class CustomSmallText extends StatelessWidget {
  const CustomSmallText({
    super.key,
    required this.text,
    this.fontSize = 12,
    this.backgroundColor = const Color(0xFFFF675C),
    this.textColor = Colors.black,
  });

  final String text;
  final double fontSize;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(15),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
