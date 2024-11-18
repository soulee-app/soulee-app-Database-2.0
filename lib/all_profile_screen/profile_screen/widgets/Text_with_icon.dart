import 'package:flutter/material.dart';

class TextWithIcon extends StatelessWidget {
  const TextWithIcon({
    super.key,
    required this.text,
    required this.icon,
    this.fontSize = 15,
  });

  final String text;
  final IconData icon;
  final double fontSize;


  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFFF675C),
      borderRadius: BorderRadius.circular(15),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.black,),
            const SizedBox(width: 5),
            Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Icon(Icons.add, color: Colors.black,),
          ],
        ),
      ),
    );
  }
}
