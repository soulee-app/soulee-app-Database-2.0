import 'package:flutter/material.dart';
import 'custome_text.dart';

class CustomTextList extends StatelessWidget {
  const CustomTextList({
    super.key,
    required this.texts,
  });

  final List<String> texts;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 3,
      runSpacing: 4.0,
      alignment: WrapAlignment.center,
      children: texts.map((text) => CustomText(text: text)).toList(),
    );
  }
}
