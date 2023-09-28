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
  Color backgroundColor() {
    return  Color(0x00000000);
  }

  // Add a method to set the MQTT command
  void setMqttCommand(String command) {
    mqttCommand = command;
  }
  @override
  void update(double dt) {
    //TODO: Update player's position based on MQTT commands (left, right, up, down)
    print('Players count: ${players.length}, Balloons count: ${balloons.length}');
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
      textPainter.paint(canvas, Offset(10, players.indexOf(player) * 30.0 + 10));
    });
  }
}
