import 'dart:ui';

import 'package:flame/palette.dart';

class Player {
  final Paint paint;
  Rect rect;
  int score = 0;

  Player() :
        paint = Paint()..color = BasicPalette.green.color, // Create a Paint object and set its color
        rect = Rect.fromLTWH(100, 100, 50, 50);

  void render(Canvas canvas) {
    canvas.drawRect(rect, paint);
  }

  void update(String mqttCommand) {
    //TODO: Update player's position based on MQTT commands (left, right, up, down)
    switch (mqttCommand) {
      case "up":
        rect = rect.translate(0, -5); // Move the player up by 5 pixels
        break;
      case "down":
        rect = rect.translate(0, 5); // Move the player down by 5 pixels
        break;
      case "left":
        rect = rect.translate(-5, 0); // Move the player left by 5 pixels
        break;
      case "right":
        rect = rect.translate(5, 0); // Move the player right by 5 pixels
        break;
      default:
      // Handle other commands or errors
        break;
    }
  }
}