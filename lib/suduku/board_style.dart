import 'package:flutter/material.dart';
import 'styles.dart';

MaterialColor emptyColor(bool gameOver) =>
    gameOver ? Styles.primaryColor : Styles.secondaryColor;

Color buttonColor(int k, int i) {
  Color color;
  if (([0, 1, 2].contains(k) && [3, 4, 5].contains(i)) ||
      ([3, 4, 5].contains(k) && [0, 1, 2, 6, 7, 8].contains(i)) ||
      ([6, 7, 8].contains(k) && [3, 4, 5].contains(i))) {
    if (Styles.primaryBackgroundColor == Styles.darkGrey) {
      color = Styles.grey;
    } else {
      color = Colors.grey[300]!;
    }
  } else {
    color = Styles.primaryBackgroundColor;
  }

  return color;
}

double buttonSize() {
  double size = 36;

  return size;
}

double buttonFontSize() {
  double size = 16;
  return size;
}

BorderRadiusGeometry buttonEdgeRadius(int k, int i) {
  if (k == 0 && i == 0) {
    return const BorderRadius.only(topLeft: Radius.circular(5));
  } else if (k == 0 && i == 8) {
    return const BorderRadius.only(topRight: Radius.circular(5));
  } else if (k == 8 && i == 0) {
    return const BorderRadius.only(bottomLeft: Radius.circular(5));
  } else if (k == 8 && i == 8) {
    return const BorderRadius.only(bottomRight: Radius.circular(5));
  }
  return BorderRadius.circular(0);
}

class SudokuBoardStyle {
  // Regular button style for user-entered numbers
  static ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.black,
    backgroundColor: Colors.white, // Normal text color
    padding: const EdgeInsets.all(16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  // Fixed button style for numbers that were in the original puzzle
  static ButtonStyle fixedButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.black87,
    backgroundColor: Colors.grey.shade300, // Fixed text color
    padding: const EdgeInsets.all(16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  // Error button style for incorrect entries
  static ButtonStyle errorButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: Colors.redAccent, // Error text color
    padding: const EdgeInsets.all(16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  // Text style for numbers entered by the user
  static TextStyle textStyle = const TextStyle(
    fontSize: 18,
    color: Colors.black,
    fontWeight: FontWeight.normal,
  );

  // Text style for numbers that were in the original puzzle
  static TextStyle fixedButtonTextStyle = const TextStyle(
    fontSize: 18,
    color: Colors.black87,
    fontWeight: FontWeight.bold,
  );

  // Error text style for incorrect numbers
  static TextStyle errorTextStyle = const TextStyle(
    fontSize: 18,
    color: Colors.white, // Error text color
    fontWeight: FontWeight.bold,
  );
}
