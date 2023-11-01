import 'package:balooner/game/balooner_game.dart';
import 'package:balooner/game/game_Over.dart';
import 'package:balooner/models/mqtt_app_state.dart';
import 'package:balooner/providers/mqtt_service_provider.dart';
import 'package:balooner/services/mqtt_service.dart';
import 'package:balooner/widgets/status_bar.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DisplayScreen extends ConsumerStatefulWidget {
  const DisplayScreen({Key? key}) : super(key: key);

  @override
  _DisplayScreenState createState() => _DisplayScreenState();
}

class _DisplayScreenState extends ConsumerState<DisplayScreen> {
  final _controller = ScrollController();
  late MQTTManager _manager = MQTTManager();
  late BaloonerGame baloonerGame;

  @override
  void initState() {
    super.initState();
    _manager = ref.read(mqttManagerProvider);
    baloonerGame = BaloonerGame(_manager);
  }

  @override
  Widget build(BuildContext context) {
    _manager = ref.watch(mqttManagerProvider);
    baloonerGame.updateMqttManager(_manager);
    print(" the state upon build is ${_manager.currentState.getHistoryText}");

    if (_controller.hasClients) {
      _controller.jumpTo(_controller.position.maxScrollExtent);
    }

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: _manager.currentState == null
            ? CircularProgressIndicator()
            : _buildColumn(_manager),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('MQTT Display'),
      backgroundColor: Colors.greenAccent,
      actions: <Widget>[
        if (_manager.currentState != null &&
            _manager.currentState.getAppConnectionState ==
                MQTTAppConnectionState.connectedSubscribed)
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('settings_route');
              },
              child: const Icon(
                Icons.settings,
                size: 26.0,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildColumn(MQTTManager manager) {
    return Column(
      children: <Widget>[
        Consumer(builder: (context, ref, child) {
          return StatusBar(
            statusMessage: prepareStateMessageFrom(
                _manager.currentState.getAppConnectionState),
          );
        }),
        Expanded(
          child: GameWidget(game: baloonerGame,
    overlayBuilderMap: {
    'GameOver': (_, game) {
    if (baloonerGame.timer.finished) {
    // Display your custom game over widget here
    return GameOver(game: baloonerGame);
    }
    return Container();
    },
    },
        ),
        ),
      ],
    );
  }


  }

