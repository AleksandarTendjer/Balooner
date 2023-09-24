import 'dart:ui';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:balooner/models/Player.dart';
import 'package:balooner/models/Baloon.dart';
import 'package:balooner/services/mqtt_service.dart';
class Game extends FlameGame {
  final MQTTManager mqttManager;
  final List<Player> players = [];
  final List<Balloon> balloons = [];

  Game({required this.mqttManager});

  @override
  void update(double dt) {
    //TODO: Update player's position based on MQTT commands (left, right, up, down)

    players.forEach((player) => player.update('UP'));
    balloons.forEach((balloon) => balloon.update(dt));

    for (final player in players) {
      for (final balloon in balloons) {
        if (player.rect.overlaps(balloon.rect)) {
          player.score++;
          balloons.remove(balloon);
          break;
        }
      }
    }
  }

  @override
  void render(Canvas canvas) {
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
