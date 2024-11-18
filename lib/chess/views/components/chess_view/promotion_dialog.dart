import 'package:flutter/cupertino.dart';

import '../../../logic/chess_piece.dart';
import '../../../model/chess_app_model.dart';
import 'promotion_option.dart';

const PROMOTIONS = [
  ChessPieceType.queen,
  ChessPieceType.rook,
  ChessPieceType.bishop,
  ChessPieceType.knight
];

class PromotionDialog extends StatelessWidget {
  final ChessAppModel appModel;

  const PromotionDialog(this.appModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      actions: [
        SizedBox(
          height: 66,
          child: Row(
            children: PROMOTIONS
                .map(
                  (promotionType) => PromotionOption(
                    appModel,
                    promotionType,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
