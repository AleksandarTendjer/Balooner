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
    final devices = mqttManager.devicesCount;
    print('player numbers are $devices');

    createPlayersAndBalloons(devices);
  }

  void createPlayersAndBalloons(int numberOfPlayers) {
    for (var i = 0; i < numberOfPlayers; i++) {
      final player = new Player(
          Vector2(100.0, 100.0 + i * 60.0)); // Create a new player
      players.add(player);
      for (var i = 0; i < 10; i++) {
        final balloon = Balloon(
          Vector2.random(),
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
      super.update(dt);
      //TODO: Update player's position based on MQTT commands (left, right, up, down)
      final command = mqttManager.listenToMessageUpdates();
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

      players.forEach((player) => player.render(canvas));
      balloons.forEach((balloon) => balloon.render(canvas));

      final textStyle = TextStyle(color: Colors.white, fontSize: 20);
      players.forEach((player) {
        final text = TextSpan(
          text: 'Player ${players.indexOf(player) + 1}: ${player.score}',
          style: textStyle,
        );
        final textPainter = TextPainter(
          text: text,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
            canvas, Offset(10, players.indexOf(player) * 30.0 + 10));
      });
    }
  }