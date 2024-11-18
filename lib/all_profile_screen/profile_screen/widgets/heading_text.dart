import 'package:flutter/cupertino.dart';

class HeadingText extends StatelessWidget {
  const HeadingText({
    super.key,
    required this.text,
    this.textStyle = const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
  });

  final String text;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: textStyle,
    );
  }
}
