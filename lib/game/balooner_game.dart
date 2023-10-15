import 'dart:io';
import 'dart:ui';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:balooner/models/Player.dart';
import 'package:balooner/models/Baloon.dart';
import 'package:balooner/services/mqtt_service.dart';
import 'package:balooner/providers/mqtt_service_provider.dart';

class BaloonerGame extends FlameGame  with HasCollisionDetection {
   late MQTTManager _mqttManager;

  MQTTManager get mqttManager => _mqttManager;

  set mqttManager(MQTTManager value) {
    _mqttManager = value;
  }
  final List<Player> players = [];
  final List<Balloon> balloons = [];


   BaloonerGame(mqttManager){
     _mqttManager=mqttManager;
     updateMqttManager(mqttManager);
   }

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
        mqttManager: mqttManager,
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
   void updateMqttManager(MQTTManager newManager) {
     print("updated the manager for all players ");
      mqttManager=newManager;
     for (var player in players) {
       print("updated the manager for the player1 ");
       player.updateMqttManager(newManager);
     }
   }
   @override
   void update(double dt) {
     if(dt==15){
       removeAll(players);
       removeAll(balloons);
       exit(100);
     }
   }
  }