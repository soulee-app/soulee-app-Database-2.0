import 'package:flutter/material.dart';
import '../chess/chessmain.dart';
import '../ludu/ludumain.dart';
import '../mysmalltown/mysmalltown.dart';
import '../suduku/sudoku.dart';
import '../tictactoe/tictactoe.dart';
import '../word_game/word.dart';

class GameScreeen extends StatefulWidget {
  const GameScreeen({super.key});

  @override
  State<GameScreeen> createState() => _GameScreeenState();
}

List<String> label = [
  'Ludu',
  'Chess',
  'Tic-Tac-Toe',
  'Sudoku',
  'Words',
  'My Small Town'
];

List<Widget> pages = [
  const LuduGame(),
  const Chess(),
  const TicTacToe(),
  const sudokoHome(),
  const WordGame(),
  const MySmallTown()
];

class _GameScreeenState extends State<GameScreeen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: GridView.builder(
              itemCount: 6,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, int index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => pages[index]));
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            'images/games/game$index.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      GameName(label[index])
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget GameName(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 35,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            name,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
