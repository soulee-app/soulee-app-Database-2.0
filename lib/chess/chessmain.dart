import 'package:flame/flame.dart';
import 'package:flutter/material.dart'; // Using Material widgets
import 'package:flutter/services.dart';
import 'logic/shared_functions.dart';
import 'model/chess_app_model.dart';
import 'views/main_menu_view.dart';

class Chess extends StatefulWidget {
  const Chess({super.key});

  @override
  _ChessState createState() => _ChessState();
}

class _ChessState extends State<Chess> {
  @override
  void initState() {
    super.initState();
    _loadFlameAssets(); // Load assets when the widget initializes
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Jura', fontSize: 16), // Updated
          bodyMedium: TextStyle(fontFamily: 'Jura'), // Updated
          bodySmall: TextStyle(
              fontFamily: 'Jura', fontSize: 12), // Example size for bodySmall
        ),
      ),
      home: const MainMenuView(),
    );
  }

  void _loadFlameAssets() async {
    List<String> pieceImages = [];
    for (var theme in PIECE_THEMES) {
      for (var color in ['black', 'white']) {
        for (var piece in [
          'king',
          'queen',
          'rook',
          'bishop',
          'knight',
          'pawn'
        ]) {
          pieceImages
              .add('pieces/${formatPieceTheme(theme)}/${piece}_$color.png');
        }
      }
    }
    await Flame.images.loadAll(pieceImages);
  }
}
