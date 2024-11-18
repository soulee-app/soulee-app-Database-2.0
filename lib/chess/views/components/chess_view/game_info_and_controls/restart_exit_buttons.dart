import 'package:flutter/cupertino.dart';

import '../../../../model/chess_app_model.dart';
import 'rounded_alert_button.dart';

class RestartExitButtons extends StatelessWidget {
  final ChessAppModel appModel;

  const RestartExitButtons(this.appModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RoundedAlertButton(
            'Restart',
            onConfirm: () {
              appModel.newGame(context);
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: RoundedAlertButton(
            'Exit',
            onConfirm: () {
              appModel.exitChessView();
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
