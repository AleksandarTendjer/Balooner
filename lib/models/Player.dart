import 'package:balooner/game/balooner_game.dart';
import 'package:balooner/models/Baloon.dart';
import 'package:balooner/services/mqtt_service.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';



class Player extends SpriteAnimationComponent with  HasGameRef<BaloonerGame> , CollisionCallbacks  {
  late int score = 0;
  late String deviceName;
  late MQTTManager mqttManager;
  var playerScore = TextComponent(
    text: 'Score: 0',
    position: Vector2(10, 10),
    textRenderer: TextPaint(
      style: TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontFamily: 'BungeeInline',
      ),
    ),
  );

  void updateMqttManager(MQTTManager newManager) {
    mqttManager = newManager;
    print("updated the manager for the player this");
  }

  Player(
      {required super.position,
      required this.mqttManager,
      required this.deviceName})
      : super(size: Vector2.all(20), anchor: Anchor.center);

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
    add(CircleHitbox());

  }
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent  other) {
    if (other is Balloon) {
      score++;
      other.removeFromParent();
    } else if (other is Player) {
      other.position -= Vector2(10, 10);
      print(" collision with player ");
    }
  }
  void move(Vector2 delta) {
    position.add(delta);
  }
  void updatePositionOnCommand(String deviceCommand) {
    final double moveSpeed =
        15; // Adjust this value to control the player's movement speed
    Vector2 currentPosition = position;
    final commandParts = deviceCommand.split('/');

    if (commandParts[1] == deviceName) {
      final command = commandParts.last;
      print('$command');
      switch (command) {
        case "up":
          currentPosition.y -= moveSpeed;
          move(position);
          break;
        case "down":
          currentPosition.y += moveSpeed;
          move(position);
          break;
        case "left":
          currentPosition.x -= moveSpeed;
          move(position);
          break;
        case "right":
          currentPosition.x += moveSpeed;
          move(position);
          break;
        default:
          // Handle other commands or errors
          break;
      }
    } else {
      print(
          'the device name does not match $deviceName !== ${commandParts[1]}');
    }
  }
  @override
  void update(double dt) {
    final command = mqttManager.currentState.getReceivedText;
    this.updatePositionOnCommand(command);
    super.update(dt);
    mqttManager.currentState.clearText();
    playerScore.text = 'Score: ${score}';

  }

}
