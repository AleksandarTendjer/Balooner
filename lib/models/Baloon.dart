import 'dart:math';

import 'package:balooner/models/Player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';



class Balloon extends CircleComponent
with HasGameReference<FlameGame>, CollisionCallbacks  {
  double speedX = 1.0; // Initial horizontal speed
  double speedY = 0.0; // Initial vertical speed
  double changeDirectionTime = 5.0; // Time to change direction (in seconds)
  double elapsedTime = 0.0; // Elapsed time since the last direction change

  late CircleHitbox baloonCircle;
  Balloon(Vector2 position)
      : super();
  @override
  @override
  Future<void> onLoad() async {
    super.onLoad();
    final defaultPaint = Paint();
    anchor = Anchor.center;
    baloonCircle = CircleHitbox()
      ..paint = defaultPaint
      ..size = Vector2.all(10)
      ..renderShape = true;
    add(baloonCircle);
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent  other) {
    baloonCircle.paint.color=Colors.amberAccent;
    if (other is Player) {
      // Increase the player's score and remove the balloon
      other.score++;
    }
  }

  @override
  void update(double dt) {
    elapsedTime += dt;

    position.x += speedX;
    position.y += speedY;

    if (elapsedTime >= changeDirectionTime) {
      final random = Random();
      speedX = (random.nextDouble() - 0.5) * 2.0; // Random horizontal speed between -1 and 1
      speedY = (random.nextDouble() - 0.5) * 2.0; // Random vertical speed between -1 and 1

      elapsedTime = 0.0;
    }
  }
}
