import 'dart:math';

import 'package:balooner/game/balooner_game.dart';
import 'package:balooner/models/Player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';



class Balloon  extends SpriteAnimationComponent
with HasGameRef<BaloonerGame>, CollisionCallbacks  {
  double speedX = 1.0; // Initial horizontal speed
  double speedY = 0.0; // Initial vertical speed
  double changeDirectionTime = 5.0; // Time to change direction (in seconds)
  double elapsedTime = 0.0; // Elapsed time since the last direction change

  Balloon({
    required super.position,
  }): super(size: Vector2.all(20), anchor: Anchor.center);

  @override
  Future<void>? onLoad() async {
    super.onLoad();
    animation = SpriteAnimation.fromFrameData(
      gameRef.images.fromCache('ember.png'),
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2.all(16),
        stepTime: 0.70,
      ),
    );
    print('created the balloon');

  }
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent  other) {
    if (other is Player) {
      // Increase the player's score and remove the balloon
      other.score++;
    }
  }

  @override
  void update(double dt) {
    if (position.x < 0 || position.x > gameRef.size.x) {
      speedX = -speedX; // Reverse horizontal direction
    }
    if (position.y < 0 || position.y > gameRef.size.y) {
      speedY = -speedY; // Reverse vertical direction
    }
    elapsedTime += dt;
    position.x += speedX * dt;
    position.y += speedY*dt;

    print('positition ballon is ${position.x} and ${position.y}');
    if (elapsedTime >= changeDirectionTime) {
      final random = Random();
      speedX = (random.nextDouble() - 0.5) * 2.0; // Random horizontal speed between -1 and 1
      speedY = (random.nextDouble() - 0.5) * 2.0; // Random vertical speed between -1 and 1

      elapsedTime = 0.0;
    }
    super.update(dt);

  }
}
