import '../model/chess_app_model.dart';
import '../views/components/main_menu_view/game_options/side_picker.dart';
import 'chess_piece.dart';

int tileToRow(int tile) {
  return (tile / 8).floor();
}

int tileToCol(int tile) {
  return tile % 8;
}

double getXFromTile(int tile, double tileSize, ChessAppModel appModel) {
  return appModel.flip &&
          appModel.playingWithAI &&
          appModel.playerSide == Player.player2
      ? (7 - tileToCol(tile)) * tileSize
      : tileToCol(tile) * tileSize;
}

double getYFromTile(int tile, double tileSize, ChessAppModel appModel) {
  return appModel.flip &&
          appModel.playingWithAI &&
          appModel.playerSide == Player.player2
      ? (7 - tileToRow(tile)) * tileSize
      : tileToRow(tile) * tileSize;
}

Player oppositePlayer(Player player) {
  return player == Player.player1 ? Player.player2 : Player.player1;
}

String formatPieceTheme(String themeString) {
  return themeString.toLowerCase().replaceAll(' ', '');
}

String pieceTypeToString(ChessPieceType type) {
  return type.toString().substring(type.toString().indexOf('.') + 1);
}
