import 'package:flutter/material.dart';

import '../../../../model/chess_app_model.dart';
import 'timer_widget.dart';

class Timers extends StatelessWidget {
  final ChessAppModel appModel;

  const Timers(this.appModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return appModel.timeLimit != 0
        ? Column(
            children: [
              Container(
                child: Row(
                  children: [
                    TimerWidget(
                      timeLeft: appModel.player1TimeLeft,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10),
                    TimerWidget(
                      timeLeft: appModel.player2TimeLeft,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],
          )
        : Container();
  }
}
