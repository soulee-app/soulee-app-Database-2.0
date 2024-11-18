import 'package:flutter/cupertino.dart';

import '../../../logic/chess_piece.dart';
import '../../../logic/shared_functions.dart';
import '../../../model/chess_app_model.dart';
import '../main_menu_view/game_options/side_picker.dart';

class PromotionOption extends StatelessWidget {
  final ChessAppModel appModel;
  final ChessPieceType promotionType;

  const PromotionOption(this.appModel, this.promotionType, {super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      child: Image(
        image: AssetImage(
          'assets/images/pieces/${formatPieceTheme(appModel.pieceTheme)}'
          '/${pieceTypeToString(promotionType)}_${_playerColor()}.png',
        ),
      ),
      onPressed: () {
        appModel.game?.promote(promotionType);
        appModel.update();
        Navigator.pop(context);
      },
    );
  }

  String _playerColor() {
    return appModel.turn == Player.player1 ? 'white' : 'black';
  }
}
