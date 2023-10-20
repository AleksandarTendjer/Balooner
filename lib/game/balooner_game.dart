import 'package:balooner/game/baloon_Manager.dart';
import 'package:balooner/game/game_world.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:balooner/models/Player.dart';
import 'package:balooner/models/Baloon.dart';
import 'package:balooner/services/mqtt_service.dart';
import 'package:flame/flame.dart';


class BaloonerGame extends FlameGame  with HasCollisionDetection {
   late MQTTManager _mqttManager;
     Timer timer=Timer(15);
   final GameWorld game_world = GameWorld();
   late CameraComponent primaryCamera;
  late BalLoonManager balloonManager;
   MQTTManager get mqttManager => _mqttManager;
   // Returns the size of the playable area of the game window.
   Vector2 fixedResolution = Vector2(540, 960);

  set mqttManager(MQTTManager value) {
    _mqttManager = value;
  }

  final List<Player> players = [];
  final List<Balloon> balloons = [];

  BaloonerGame(mqttManager) {
    print("new ballooner game isntance");
    _mqttManager = mqttManager;
    updateMqttManager(mqttManager);
    balloonManager=BalLoonManager();
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
   await add(game_world);
    await images.loadAll(['water_enemy.png', 'star.png']);
    final devices = mqttManager.devicesCount;
    // Somewhere in your code.
    primaryCamera = CameraComponent.withFixedResolution(
      world: world,
      width: fixedResolution.x,
      height: fixedResolution.y,
    )..viewfinder.position = fixedResolution / 2;
    await add(primaryCamera);
    createPlayersAndBalloons(devices);

    game_world.add(balloonManager);
    timer.start();
  }


   void createPlayersAndBalloons(int numberOfPlayers) {
    for (var i = 0; i < numberOfPlayers; i++) {
      print('canvas size is: ${canvasSize.x/2} and ${canvasSize.y/2}');
      final player =  Player(
        mqttManager: mqttManager,
        position:  Vector2(canvasSize.x/2, canvasSize.y/2)
      );
      players.add(player);

    }
    game_world.addAll(players);
  }

  void updateMqttManager(MQTTManager newManager) {
    mqttManager = newManager;
    for (var player in players) {
      print("updated the manager for the player1 ");
      player.updateMqttManager(newManager);
    }
  }

   @override
   void update(double dt) {
     super.update(dt);
      timer.update(dt);
     // Check if the timer has finished
     if (timer.finished) {
        print('game over');
        game_world.removeAll(players);
        game_world.removeAll(balloons);
       overlays.add('GameOver');
        pauseEngine();
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

   void reset(){
    for (var player in players) {player.score==0; }}

}
