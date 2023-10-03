import 'package:balooner/models/Baloon.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';



class Player extends PositionComponent with  CollisionCallbacks  {
  late int score=0;
  late RectangleHitbox playerShape;
  late Sprite sprite;
  Player(Vector2 position)
      : super();
  @override
  Future<void>? onLoad() async {
    final defaultPaint = Paint();
    sprite = await Sprite.load('assets/bomb.png');
    size = Vector2(100, 100);
    anchor = Anchor.center;
    playerShape = RectangleHitbox()
      ..paint = defaultPaint
      ..renderShape = true;
    add(playerShape);
    return super.onLoad();
  }
  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent  other) {
    playerShape.paint.color=Colors.amberAccent;
    if (other is Balloon) {
      // Increase the player's score and remove the balloon
      score++;
      other.removeFromParent();
    }
  }
  void updatePositionOnCommand(String command) {
    final double moveSpeed = 5.0; // Adjust this value to control the player's movement speed

    switch (command) {
      case "up":
        position.y -= moveSpeed; // Move the player up
        break;
      case "down":
        position.y += moveSpeed; // Move the player down
        break;
      case "left":
        position.x -= moveSpeed; // Move the player left
        break;
      case "right":
        position.x += moveSpeed; // Move the player right
        break;
      default:
      // Handle other commands or errors
        break;
    }
  }
}
