import 'package:flutter/cupertino.dart';

class HeadingText extends StatelessWidget {
  const HeadingText({
    super.key, required this.text,this.fontSize=15,
  });
  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 2,
      style: TextStyle(
        fontSize:fontSize,
        fontWeight: FontWeight.bold,
        overflow: TextOverflow.ellipsis,

      ),
    );
  }
}