import 'package:balooner/game/balooner_game.dart';
import 'package:balooner/models/Baloon.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';



class Player extends SpriteAnimationComponent with  HasGameRef<BaloonerGame> , CollisionCallbacks  {
  late int score=0;
  Player({
    required super.position,
  }) : super(size: Vector2.all(64), anchor: Anchor.center);

  @override
  Future<void>? onLoad() async {
    super.onLoad();
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('water_enemy.png'),
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2.all(20),
        stepTime: 0.12,
      ),
    );
    print('created the player');

  }
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent  other) {
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
