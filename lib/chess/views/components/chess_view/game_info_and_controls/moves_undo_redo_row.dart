import 'package:flutter/cupertino.dart';

import '../../../../model/chess_app_model.dart';
import 'moves_undo_redo_row/move_list.dart';
import 'moves_undo_redo_row/undo_redo_buttons.dart';

class MovesUndoRedoRow extends StatelessWidget {
  final ChessAppModel appModel;

  const MovesUndoRedoRow(this.appModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            appModel.showMoveHistory
                ? Expanded(child: MoveList(appModel))
                : Container(),
            appModel.showMoveHistory && appModel.allowUndoRedo
                ? const SizedBox(width: 10)
                : Container(),
            appModel.allowUndoRedo
                ? Expanded(child: UndoRedoButtons(appModel))
                : Container(),
          ],
        ),
        appModel.showMoveHistory || appModel.allowUndoRedo
            ? const SizedBox(height: 10)
            : Container(),
      ],
    );
  }
}
