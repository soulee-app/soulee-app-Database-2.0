import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame/sprite.dart';

import '../model/chess_app_model.dart';
import '../views/components/main_menu_view/game_options/side_picker.dart';
import 'chess_piece.dart';
import 'shared_functions.dart';

class ChessPieceSprite {
  ChessPieceType? type;
  String? pieceTheme;
  int? tile;
  Sprite? sprite;
  double? spriteX;
  double? spriteY;
  double offsetX = 0;
  double offsetY = 0;

  ChessPieceSprite(ChessPiece piece, String pieceTheme) {
    tile = piece.tile;
    type = piece.type;
    this.pieceTheme = pieceTheme;
    initSprite(piece);
  }

  void update(double tileSize, ChessAppModel appModel, ChessPiece piece) {
    if (piece.type != type) {
      type = piece.type;
      initSprite(piece);
    }
    if (piece.tile != tile) {
      tile = piece.tile;
      offsetX = 0;
      offsetY = 0;
    }
    var destX = getXFromTile(tile ?? 0, tileSize, appModel);
    var destY = getYFromTile(tile ?? 0, tileSize, appModel);
    if ((destX - (spriteX ?? 0)).abs() <= 0.1) {
      spriteX = destX;
      offsetX = 0;
    } else {
      if (offsetX == 0) {
        offsetX = (destX - (spriteX ?? 0)) / 10;
      }
      if (spriteX != null) {
        spriteX = (spriteX ?? 0) + offsetX;
      }
      playSound(destX, destY, appModel);
    }
    if ((destY - (spriteY ?? 0)).abs() <= 0.1) {
      spriteY = destY;
      offsetY = 0;
    } else {
      if (offsetY == 0) {
        offsetY += (destY - (spriteY ?? 0)) / 10;
      }
      if (spriteX != null) {
        spriteY = (spriteY ?? 0) + offsetY;
      }
      playSound(destX, destY, appModel);
    }
  }

  void playSound(double destX, double destY, ChessAppModel appModel) async {
    if ((destX - (spriteX ?? 0)).abs() <= 0.1 &&
        (destY - (spriteY ?? 0)).abs() <= 0.1) {
      if (appModel.soundEnabled) {
        //await FlameAudio.audioCache.load('piece_moved.mp3');
        FlameAudio.play('piece_moved.mp3');
      }
    }
  }

  void initSprite(ChessPiece piece) async {
    String color = piece.player == Player.player1 ? 'white' : 'black';
    String pieceName = pieceTypeToString(piece.type);
    if (piece.type == ChessPieceType.promotion) {
      pieceName = 'pawn';
    }
    sprite = Sprite(await Flame.images.load(
        'pieces/${formatPieceTheme(pieceTheme ?? "")}/${pieceName}_$color.png'));
  }

  void initSpritePosition(double tileSize, ChessAppModel appModel) {
    spriteX = getXFromTile(tile ?? 0, tileSize, appModel);
    spriteY = getYFromTile(tile ?? 0, tileSize, appModel);
  }
}
