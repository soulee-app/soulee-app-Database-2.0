import 'dart:async';
import 'package:flutter/material.dart';

class SoloPlayer extends StatefulWidget {
  const SoloPlayer({super.key});

  @override
  State<SoloPlayer> createState() => _SoloPlayerState();
}

class _SoloPlayerState extends State<SoloPlayer> {
  static const String PLAYER_X = "X"; // Human
  static const String PLAYER_Y = "O"; // Bot

  late String currentPlayer;
  late bool gameEnd;
  late List<String> occupied;
  bool isBotThinking = false;

  @override
  void initState() {
    initializeGame();
    super.initState();
  }

  void initializeGame() {
    currentPlayer = PLAYER_X;
    gameEnd = false;
    occupied = ["", "", "", "", "", "", "", "", ""]; // 9 empty places
    isBotThinking = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _headerText(),
            _gameContainer(),
            if (isBotThinking) _botThinkingIndicator(),
            _restartButton(),
          ],
        ),
      ),
    );
  }

  Widget _headerText() {
    return Column(
      children: [
        const Text(
          "Tic Tac Toe - Solo",
          style: TextStyle(
            color: Colors.green,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "$currentPlayer's turn",
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _gameContainer() {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.height / 2,
      margin: const EdgeInsets.all(8),
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          itemCount: 9,
          itemBuilder: (context, int index) {
            return _box(index);
          }),
    );
  }

  Widget _box(int index) {
    return InkWell(
      onTap: () {
        if (gameEnd || occupied[index].isNotEmpty || isBotThinking) {
          return;
        }

        setState(() {
          occupied[index] = currentPlayer;
          changeTurn();
          checkForWinner();
          checkForDraw();

          if (!gameEnd && currentPlayer == PLAYER_Y) {
            botMove();
          }
        });
      },
      child: Container(
        color: occupied[index].isEmpty
            ? Colors.black26
            : occupied[index] == PLAYER_X
                ? Colors.blue
                : Colors.orange,
        margin: const EdgeInsets.all(8),
        child: Center(
          child: Text(
            occupied[index],
            style: const TextStyle(fontSize: 50),
          ),
        ),
      ),
    );
  }

  Widget _restartButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          initializeGame();
        });
      },
      child: const Text("Restart Game"),
    );
  }

  Widget _botThinkingIndicator() {
    return const Column(
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 8),
        Text(
          "Bot is thinking...",
          style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  void changeTurn() {
    if (currentPlayer == PLAYER_X) {
      currentPlayer = PLAYER_Y;
    } else {
      currentPlayer = PLAYER_X;
    }
  }

  void botMove() async {
    setState(() {
      isBotThinking = true;
    });

    // Wait for 1 second to simulate thinking
    await Future.delayed(const Duration(seconds: 1));

    // First, check if there's a winning move for the bot to block the player
    int? blockingMove = getBlockingMove();

    if (blockingMove != null) {
      // Bot blocks player's winning move
      setState(() {
        occupied[blockingMove] = PLAYER_Y;
        isBotThinking = false;
        changeTurn();
        checkForWinner();
        checkForDraw();
      });
    } else {
      // If no blocking move, make a random move
      List<int> availablePositions = [];
      for (int i = 0; i < occupied.length; i++) {
        if (occupied[i].isEmpty) {
          availablePositions.add(i);
        }
      }

      if (availablePositions.isNotEmpty) {
        setState(() {
          int botIndex = availablePositions.first; // Take the first available
          occupied[botIndex] = PLAYER_Y;
          isBotThinking = false;
          changeTurn();
          checkForWinner();
          checkForDraw();
        });
      }
    }
  }

  // This function returns the index of the blocking move if available, otherwise null
  int? getBlockingMove() {
    List<List<int>> winningList = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var winningPos in winningList) {
      String pos0 = occupied[winningPos[0]];
      String pos1 = occupied[winningPos[1]];
      String pos2 = occupied[winningPos[2]];

      // Check if two positions are occupied by the player and the third is empty
      if (pos0 == PLAYER_X && pos1 == PLAYER_X && pos2.isEmpty) {
        return winningPos[2]; // Block at position 2
      } else if (pos0 == PLAYER_X && pos2 == PLAYER_X && pos1.isEmpty) {
        return winningPos[1]; // Block at position 1
      } else if (pos1 == PLAYER_X && pos2 == PLAYER_X && pos0.isEmpty) {
        return winningPos[0]; // Block at position 0
      }
    }

    // No blocking move needed
    return null;
  }

  void checkForWinner() {
    List<List<int>> winningList = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var winningPos in winningList) {
      String playerPosition0 = occupied[winningPos[0]];
      String playerPosition1 = occupied[winningPos[1]];
      String playerPosition2 = occupied[winningPos[2]];

      if (playerPosition0.isNotEmpty) {
        if (playerPosition0 == playerPosition1 &&
            playerPosition0 == playerPosition2) {
          showGameOverMessage("Player $playerPosition0 Won");
          gameEnd = true;
          return;
        }
      }
    }
  }

  void checkForDraw() {
    if (gameEnd) return;

    bool draw = true;
    for (var occupiedPlayer in occupied) {
      if (occupiedPlayer.isEmpty) {
        draw = false;
      }
    }

    if (draw) {
      showGameOverMessage("Draw");
      gameEnd = true;
    }
  }

  void showGameOverMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          "Game Over \n$message",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
