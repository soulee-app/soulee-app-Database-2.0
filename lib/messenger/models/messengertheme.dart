import 'package:flutter/material.dart';

class MessengerTheme {
  String? name;
  LinearGradient? background;

  MessengerTheme({
    this.name,
    this.background,
  });
}

List<MessengerTheme> get messengerthemeList {
  return [
    MessengerTheme(
      name: 'Light',
      background: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFFF675C),
          Colors.white,
        ],
      ),
    ),
    MessengerTheme(
      name: 'Grey',
      background: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xffb2b2b2),
          Color(0xff4e4e4e),
        ],
      ),
    ),
    MessengerTheme(
      name: 'Dark',
      background: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xff1e1e1e),
          Color(0xff2e2e2e),
        ],
      ),
    ),
    MessengerTheme(
      name: 'Lewis',
      background: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xff423428),
          Color(0xff423428),
        ],
      ),
    ),
    MessengerTheme(
      name: 'Cherry Funk',
      background: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xff434783),
          Color(0xffdc3b39),
        ],
      ),
    ),
    MessengerTheme(
      name: 'Sage',
      background: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF83886F),
          Color(0xFF000000),
        ],
      ),
    ),
    MessengerTheme(
      name: 'Warm Tan',
      background: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF866749),
          Color(0xFF000000),
        ],
      ),
    ),
    MessengerTheme(
      name: 'Jargon Jade',
      background: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF517970),
          Color(0xFF000000),
        ],
      ),
    ),
  ];
}
