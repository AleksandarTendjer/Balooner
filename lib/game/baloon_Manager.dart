import 'dart:math';

import 'package:balooner/game/balooner_game.dart';
import 'package:balooner/models/Baloon.dart';
import 'package:flame/components.dart';

class BalLoonManager extends Component with HasGameRef<BaloonerGame>{
  // The timer which runs the enemy spawner code at regular interval of time.
  late Timer timer;
  late Timer freezeTimer;
  BalLoonManager():super(){
    timer = Timer(1, onTick: spawnBallon, repeat: true);

    // Sets freeze time to 2 seconds. After 2 seconds spawn timer will start again.
    freezeTimer = Timer(2, onTick: () {
      timer.start();
    });
  }
  Random random = Random();
  @override
  void onRemove() {
    super.onRemove();
    // Stop the timer if current enemy manager is getting removed from the
    // game instance.
    timer.stop();
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Update timers with delta time to make them tick.
    timer.update(dt);
    freezeTimer.update(dt);
  }

  // Stops and restarts the timer. Should be called
  // while restarting and exiting the game.
  void reset() {
    timer.stop();
    timer.start();
  }

  // Spawns a new enemy at random position at the top of the screen.
  void spawnBallon() {

    // random.nextDouble() generates a random number between 0 and 1.
    // Multiplying it by game.fixedResolution.x makes sure that the value remains between 0 and width of screen.
    Vector2 position = Vector2(random.nextDouble() * game.fixedResolution.x, 0);
    Balloon balloon= Balloon(position: position);
    game.game_world.add(balloon);

  }
}