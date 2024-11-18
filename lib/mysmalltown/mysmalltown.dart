import 'package:flutter/material.dart';

import '../main_screens/games_screen.dart';

class MySmallTown extends StatefulWidget {
  const MySmallTown({super.key});

  @override
  State<MySmallTown> createState() => _MySmallTownState();
}

class _MySmallTownState extends State<MySmallTown> {
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
      body: const Center(
        child: Text(
          'This Game Under Development',
          style: TextStyle(
              color: Color(0xFFFF675C),
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
