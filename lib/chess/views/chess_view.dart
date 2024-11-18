import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../model/chess_app_model.dart';
import 'components/chess_view/chess_board_widget.dart';
import 'components/chess_view/game_info_and_controls.dart';
import 'components/chess_view/game_info_and_controls/game_status.dart';
import 'components/chess_view/promotion_dialog.dart';
import 'components/shared/bottom_padding.dart';

class ChessView extends StatefulWidget {
  final ChessAppModel appModel;

  const ChessView(this.appModel, {super.key});

  @override
  _ChessViewState createState() => _ChessViewState(appModel);
}

class _ChessViewState extends State<ChessView> {
  ChessAppModel appModel;

  _ChessViewState(this.appModel);

  @override
  Widget build(BuildContext context) {
    return Consumer<ChessAppModel>(
      builder: (context, appModel, child) {
        if (appModel.promotionRequested) {
          appModel.promotionRequested = false;
          WidgetsBinding.instance
              .addPostFrameCallback((_) => _showPromotionDialog(appModel));
        }
        return WillPopScope(
          onWillPop: _willPopCallback,
          child: Container(
            decoration: BoxDecoration(gradient: appModel.theme.background),
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                const Spacer(),
                ChessBoardWidget(appModel),
                const SizedBox(height: 30),
                const GameStatus(),
                const Spacer(),
                GameInfoAndControls(appModel),
                const BottomPadding(),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPromotionDialog(ChessAppModel appModel) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return PromotionDialog(appModel);
      },
    );
  }

  Future<bool> _willPopCallback() async {
    appModel.exitChessView();

    return true;
  }
}
