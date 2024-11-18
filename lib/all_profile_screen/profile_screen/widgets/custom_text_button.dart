import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    required this.text,
    required this.icon,
    this.onTap,
    this.fontSize = 15,
  });

  final String text;
  final IconData icon;
  final void Function()? onTap;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        color: const Color(0xFFFF675C),
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
          child: Row(
            children: [
              Icon(icon, color: Colors.black),
              const SizedBox(width: 5),
              Text(
                text,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
