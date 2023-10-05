import 'package:balooner/game/balooner_game.dart';
import 'package:balooner/models/Baloon.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';



class Player extends SpriteAnimationComponent with  HasGameRef<BaloonerGame> , CollisionCallbacks  {
  late int score=0;
  Player({
    required super.position,
  }) : super(size: Vector2.all(20), anchor: Anchor.center);

  @override
  Future<void>? onLoad() async {
    super.onLoad();
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('water_enemy.png'),
      SpriteAnimationData.sequenced(
        amount: 2,
        textureSize: Vector2.all(16),
        stepTime: 0.2,
      ),
    );
    print('created the player');

  }
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent  other) {
    if (other is Balloon) {
      score++;
      other.removeFromParent();
    }
  }
  void updatePositionOnCommand(String deviceCommand) {
    final double moveSpeed = 0.01; // Adjust this value to control the player's movement speed
    print('deviceCommand is $deviceCommand');
    print('positition player is ${position.x} and ${position.y}');
  final command=deviceCommand.split('/').last;
  print('$command');
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
  @override
  void update(double dt) {
    super.update(dt);
  }
}
