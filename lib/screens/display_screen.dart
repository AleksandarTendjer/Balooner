import 'package:balooner/game/balooner_game.dart';
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
  late BaloonerGame game;

  @override
  void initState() {
    super.initState();
    _manager = ref.read(mqttManagerProvider);
    game = BaloonerGame(_manager);
  }

  @override
  Widget build(BuildContext context) {
    _manager = ref.watch(mqttManagerProvider);
    game.updateMqttManager(_manager);
    print(" the state upon build is ${_manager.currentState.getHistoryText}");

    if (_controller.hasClients) {
      _controller.jumpTo(_controller.position.maxScrollExtent);
    }

    return Scaffold(
      appBar: _buildAppBar(context),
      body: _manager.currentState == null
          ? CircularProgressIndicator()
          : _buildColumn(_manager),
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
              child: Icon(
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
        // Include the Game widget and pass the GameManager
        Expanded(
          child: GameWidget(game: game),
        ),
      ],
    );
  }


  }

