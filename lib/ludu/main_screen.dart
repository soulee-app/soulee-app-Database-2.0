import 'package:flutter/material.dart';
import '../main_screens/games_screen.dart';
import 'widgets/board_widget.dart';
import 'widgets/dice_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GameScreeen()),
              );
            },
          ),
        ],
      ),
      body: const SafeArea(
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BoardWidget(),
                  Center(
                      child:
                          SizedBox(width: 50, height: 50, child: DiceWidget())),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
