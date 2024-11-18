import 'package:flutter/material.dart';
import 'package:navbar/DatabaseManager.dart';
import 'package:navbar/RunningPage/Quiz/quizPage.dart';
import 'package:navbar/RunningPage/music/MusicHomePage.dart';
import 'package:navbar/main_screens/games_screen.dart';

class RunningPage extends StatefulWidget {
  final DatabaseManager databaseManager;

  const RunningPage({super.key, required this.databaseManager});

  @override
  _RunningPageState createState() => _RunningPageState();
}

class _RunningPageState extends State<RunningPage> {
  int _selectedIndex = 0;

  // Pages to display based on the selected index
  final List<Widget> _pages = [
    const QuizPage(),
    const MusicHomePage(),
    const GameScreeen(),
  ];

  void _onButtonTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Row of navigation buttons
          Container(
            color: const Color.fromRGBO(255, 87, 87, .5),
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _NavigationButton(
                  label: "Quiz",
                  isSelected: _selectedIndex == 0,
                  onPressed: () => _onButtonTapped(0),
                ),
                _NavigationButton(
                  label: "Trends",
                  isSelected: _selectedIndex == 1,
                  onPressed: () => _onButtonTapped(1),
                ),
                _NavigationButton(
                  label: "Games",
                  isSelected: _selectedIndex == 2,
                  onPressed: () => _onButtonTapped(2),
                ),
              ],
            ),
          ),
          // Content area that changes based on the selected index
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }
}

class _NavigationButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const _NavigationButton({
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected ? const Color.fromRGBO(255, 87, 87, 1) : Colors.white,
          borderRadius: BorderRadius.circular(30), // Makes the button round
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // Adds shadow effect
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
