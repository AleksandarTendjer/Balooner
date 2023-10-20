import 'dart:math';

import 'package:balooner/game/balooner_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';



class Balloon  extends SpriteAnimationComponent
with HasGameRef<BaloonerGame>  {
  double speedY = 1.0; // Initial vertical speed
  double changeDirectionTime = 3.0; // Time to change direction (in seconds)
  double elapsedTime = 0.0; // Elapsed time since the last direction change

  Balloon({
    required super.position,
  }): super(size: Vector2.all(20), anchor: Anchor.center);

  @override
  Future<void>? onLoad() async {
    super.onLoad();
    animation = SpriteAnimation.fromFrameData(
      gameRef.images.fromCache('star.png'),
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2.all(16),
        stepTime: 0.70,
      ),
    );
    add(RectangleHitbox()..collisionType = CollisionType.passive);

  }


  @override
  void update(double dt) {
    super.update(dt);
    position+=Vector2(0,1)*speedY*10 * dt;
    if(position.y> game.fixedResolution.y) {
      removeFromParent();
    }
  }
}
