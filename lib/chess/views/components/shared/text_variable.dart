import 'package:flutter/material.dart';

class TextDefault extends StatelessWidget {
  final String text;
  final Color color;

  const TextDefault(this.text,
      {super.key, this.color = Colors.white}); // Default color set to white

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 16,
          fontFamily: 'Jura',
          color: color,
          decoration: TextDecoration.none),
    );
  }
}

class TextSmall extends StatelessWidget {
  final String text;
  final Color color;

  const TextSmall(this.text,
      {super.key, this.color = Colors.black}); // Default color set to black

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 14, // Adjusted font size for smaller text
          fontFamily: 'Jura',
          color: color,
          decoration: TextDecoration.none),
    );
  }
}

class TextRegular extends StatelessWidget {
  final String text;
  final Color color;

  const TextRegular(this.text,
      {super.key, this.color = Colors.black}); // Default color set to black

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 18, // Adjusted font size for regular text
          fontFamily: 'Jura',
          color: color,
          decoration: TextDecoration.none),
    );
  }
}

class TextLarge extends StatelessWidget {
  final String text;
  final Color color;

  const TextLarge(this.text,
      {super.key, this.color = Colors.black}); // Default color set to black

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 30, // Adjusted font size for large text
          fontFamily: 'Jura',
          color: color,
          decoration: TextDecoration.none),
    );
  }
}
