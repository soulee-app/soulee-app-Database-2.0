import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../main_screens/games_screen.dart';
import '../components/grid.dart';
import '../components/keyboard_row.dart';
import '../components/stats_box.dart';
import '../constants/words.dart';
import '../providers/controller.dart';
import '../utils/quick_box.dart';
import 'settings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String _word;

  @override
  void initState() {
    final r = Random().nextInt(words.length);
    _word = words[r];

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<Controller>(context, listen: false)
          .setCorrectWord(word: _word);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wordle'),
        centerTitle: true,
        elevation: 0,
        actions: [
          Consumer<Controller>(
            builder: (_, notifier, __) {
              if (notifier.notEnoughLetters) {
                runQuickBox(context: context, message: 'Not Enough Letters');
              }
              if (notifier.gameCompleted) {
                if (notifier.gameWon) {
                  if (notifier.currentRow == 6) {
                    runQuickBox(context: context, message: 'Phew!');
                  } else {
                    runQuickBox(context: context, message: 'Splendid!');
                  }
                } else {
                  runQuickBox(context: context, message: notifier.correctWord);
                }

                // Add a safety check before showing the dialog
                Future.delayed(const Duration(milliseconds: 4000), () {
                  if (mounted) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        showDialog(
                            context: context, builder: (_) => const StatsBox());
                      }
                    });
                  }
                });
              }

              return IconButton(
                onPressed: () async {
                  showDialog(
                      context: context, builder: (_) => const StatsBox());
                },
                icon: const Icon(Icons.bar_chart_outlined),
              );
            },
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Settings()));
            },
            icon: const Icon(Icons.settings),
          ),
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
      body: const Column(
        children: [
          Divider(
            height: 1,
            thickness: 2,
          ),
          Expanded(flex: 7, child: Grid()),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                KeyboardRow(
                  min: 1,
                  max: 10,
                ),
                KeyboardRow(
                  min: 11,
                  max: 19,
                ),
                KeyboardRow(
                  min: 20,
                  max: 29,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
