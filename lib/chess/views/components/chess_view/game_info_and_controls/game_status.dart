import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../../model/chess_app_model.dart';
import '../../main_menu_view/game_options/side_picker.dart';
import '../../shared/text_variable.dart';

class GameStatus extends StatelessWidget {
  const GameStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChessAppModel>(
      builder: (context, appModel, child) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextRegular(_getStatus(appModel)),
          !appModel.gameOver && appModel.playerCount == 1 && appModel.isAIsTurn
              ? const CupertinoActivityIndicator(radius: 12)
              : Container()
        ],
      ),
    );
  }

  String _getStatus(ChessAppModel appModel) {
    if (!appModel.gameOver) {
      if (appModel.playerCount == 1) {
        if (appModel.isAIsTurn) {
          return 'AI [Level ${appModel.aiDifficulty}] is thinking ';
        } else {
          return 'Your turn';
        }
      } else {
        if (appModel.turn == Player.player1) {
          return 'White\'s turn';
        } else {
          return 'Black\'s turn';
        }
      }
    } else {
      if (appModel.stalemate) {
        return 'Stalemate';
      } else {
        if (appModel.playerCount == 1) {
          if (appModel.isAIsTurn) {
            return 'You Win!';
          } else {
            return 'You Lose :(';
          }
        } else {
          if (appModel.turn == Player.player1) {
            return 'Black wins!';
          } else {
            return 'White wins!';
          }
        }
      }
    }
  }
}
