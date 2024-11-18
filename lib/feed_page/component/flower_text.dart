import 'package:flutter/cupertino.dart';

class FlowerText extends StatelessWidget {
  const FlowerText({
    super.key,
    required this.imagePath,
    required this.text,
  });

  final String imagePath;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 20,
          width: 20,
          child: Image.asset(imagePath, fit: BoxFit.cover),
        ),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}