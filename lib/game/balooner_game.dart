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
  String mqttCommand = "";

  BaloonerGame({required this.mqttManager});

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await images.loadAll([
      'ember.png',
      'water_enemy.png',
      'bomb.png'
    ]);
    final devices = mqttManager.devicesCount;

    createPlayersAndBalloons(devices);

  }

  void createPlayersAndBalloons(int numberOfPlayers) {
    for (var i = 0; i < numberOfPlayers; i++) {
      print('canvas size is: ${canvasSize.x/2} and ${canvasSize.y/2}');
      final player =  Player(
        position:  Vector2(canvasSize.x/2, canvasSize.y/2)
      );
      players.add(player);
      for (var i = 0; i < 10; i++) {
        final balloon = Balloon(
        position:   Vector2( canvasSize.x / 2 + i * 20,
          canvasSize.y / 2 + i * 20,
        ));
        balloons.add(balloon);
      }
    }
    addAll(players);
    addAll(balloons);
  }



    // Add a method to set the MQTT command
    void setMqttCommand(String command) {
      mqttCommand = command;
    }
    @override
    void update(double dt) {
      super.update(dt);
      final command = mqttManager.currentState.getReceivedText;
      mqttManager.currentState.clearText();
      print(' The new message command is : $command\n');
      setMqttCommand(command);
      print('Players count: ${players.length}, Balloons count: ${balloons
          .length}');
      players.forEach((player) => player.updatePositionOnCommand(mqttCommand));
      balloons.forEach((balloon) =>{ balloon.update(dt)});
    }


    @override
    void render(Canvas canvas) {
      print('Render called');
      final paint = Paint()..color = Colors.blue;
      canvas.drawRect(size.toRect(), paint);
      for (var balloon in balloons) {
        canvas.save();
        balloon.render(canvas);
        canvas.restore();
      }
      for (var player in players) {
      canvas.save();
      player.render(canvas);
      canvas.restore();
      }


    }
  }