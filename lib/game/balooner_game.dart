import 'dart:ui';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:balooner/models/Player.dart';
import 'package:balooner/models/Baloon.dart';
import 'package:balooner/services/mqtt_service.dart';

class BaloonerGame extends FlameGame  with HasCollisionDetection {
  final MQTTManager mqttManager;
  final List<Player> players = [];
  final List<Balloon> balloons = [];
  String mqttCommand = ""; // Store the MQTT command here

  BaloonerGame({required this.mqttManager});

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await images.loadAll([
      'ember.png',
      'water_enemy.png',
    ]);
    final devices = mqttManager.devicesCount;
    print('player numbers are $devices');

    createPlayersAndBalloons(devices);
  }

  void createPlayersAndBalloons(int numberOfPlayers) {
    for (var i = 0; i < numberOfPlayers; i++) {
      final player =  Player(
        position:  Vector2(canvasSize.x/2, canvasSize.y/2));
      players.add(player);
      for (var i = 0; i < 10; i++) {
        final balloon = Balloon(
        position:  Vector2.random(),
        );
        balloons.add(balloon);
      }

    }
    print('player is added ${players.length}');
    print('ballons are added ${balloons.length}');
  }
  @override
  void onAttach() {
    addAll(players);
    addAll(balloons);
  }


    // Add a method to set the MQTT command
    void setMqttCommand(String command) {
      mqttCommand = command;
    }
    @override
    void update(double dt) {
    print('update called');
      super.update(dt);
      final command = mqttManager.currentState.getReceivedText;
      mqttManager.currentState.clearText();
      print(' The new message command is : $command\n');
      setMqttCommand(command);
      print('Players count: ${players.length}, Balloons count: ${balloons
          .length}');
      players.forEach((player) => player.updatePositionOnCommand(mqttCommand));
      balloons.forEach((balloon) => balloon.update(dt));
    }


    @override
    void render(Canvas canvas) {
      print('Render called');
      final paint = Paint()..color = Colors.blue;
      canvas.drawRect(size.toRect(), paint);
      players.forEach((player) => player.render(canvas));
      balloons.forEach((balloon) => balloon.render(canvas));

    }
  }