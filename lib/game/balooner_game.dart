import 'package:balooner/models/Baloon.dart';
import 'package:balooner/models/Player.dart';
import 'package:balooner/services/mqtt_service.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';

class BaloonerGame extends FlameGame with HasCollisionDetection {
  late MQTTManager _mqttManager;

  MQTTManager get mqttManager => _mqttManager;

  set mqttManager(MQTTManager value) {
    _mqttManager = value;
  }

  final List<Player> players = [];
  final List<Balloon> balloons = [];

  BaloonerGame(mqttManager) {
    print("new ballooner game isntance");
    _mqttManager = mqttManager;
    updateMqttManager(mqttManager);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await images.loadAll(['water_enemy.png', 'star.png']);
    final devices = mqttManager.devicesCount;

    createPlayersAndBalloons(devices);
  }

  void createPlayersAndBalloons(int numberOfPlayers) {
    for (var i = 0; i < numberOfPlayers; i++) {
      print('canvas size is: ${canvasSize.x/2} and ${canvasSize.y/2}');
      final player =  Player(
        mqttManager: mqttManager,
        position:  Vector2(canvasSize.x/2, canvasSize.y/2)
      );
      players.add(player);
      for (var i = 0; i < 10; i++) {
        final balloon = Balloon(
            position: Vector2(
          canvasSize.x / 2 + i * 20,
          canvasSize.y / 2 + i * 20,
        ));
        balloons.add(balloon);
      }
    }
    addAll(players);
    addAll(balloons);
  }

  void updateMqttManager(MQTTManager newManager) {
    mqttManager = newManager;
    for (var player in players) {
      print("updated the manager for the player1 ");
      player.updateMqttManager(newManager);
    }
  }

  @override
  void onRemove() {
    // Optional based on your game needs.
    removeAll(children);
    processLifecycleEvents();
    Flame.images.clearCache();
    Flame.assets.clearCache();
    // Any other code that you want to run when the game is removed.
  }
}
