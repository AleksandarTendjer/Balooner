import 'package:balooner/models/mqtt_app_state.dart';
import 'package:balooner/providers/mqtt_service_provider.dart';
import 'package:balooner/services/mqtt_service.dart';
import 'package:balooner/widgets/status_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ControllsScreen extends ConsumerStatefulWidget {
  const ControllsScreen({super.key});

  @override
  ConsumerState<ControllsScreen> createState() => _ControllsScreenState();
}

class _ControllsScreenState extends ConsumerState<ControllsScreen> {
  static const type='controller';
  final _controller = ScrollController();
  late MQTTManager _manager;
  late String deviceName;

  @override
  Widget build(BuildContext context) {
    _manager = ref.watch(mqttManagerProvider);
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
      title: const Text('MQTT'),
      backgroundColor: Colors.greenAccent,
      actions: <Widget>[
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
        StatusBar(
          statusMessage:
          prepareStateMessageFrom(manager.currentState.getAppConnectionState),
        ),
        _buildEditableColumn(manager.currentState),
      ],
    );
  }

  Widget _buildEditableColumn(MQTTAppState currentAppState) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          _buildPublishMessageRow(currentAppState),
          const SizedBox(height: 10),
          _buildScrollableTextWith(currentAppState.getHistoryText),
        ],
      ),
    );
  }
  Widget _buildPublishMessageRow(MQTTAppState currentAppState) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildPredefinedButton('Up', 'up',currentAppState),
          ],
        ),
        SizedBox(height: 10), // Add some vertical spacing
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildPredefinedButton('Left', 'left',currentAppState),
            SizedBox(width: 20), // Add horizontal spacing between "left" and "right"
            _buildPredefinedButton('Right', 'right',currentAppState),
          ],
        ),
        SizedBox(height: 10), // Add some vertical spacing
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildPredefinedButton('Down', 'down',currentAppState),
          ],
        ),
      ],
    );
  }

  Widget _buildPredefinedButton(String buttonText, String predefinedText, MQTTAppState currentAppState) {

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        disabledForegroundColor: Colors.black38.withOpacity(0.38),
        disabledBackgroundColor: Colors.black38.withOpacity(0.12),
        textStyle: TextStyle(color: Colors.white),
      ),
      child: Text(buttonText),
      onPressed:  currentAppState.getAppConnectionState == MQTTAppConnectionState.connectedSubscribed
          ? () {
        _publishMessage(predefinedText);
      }   : null
    );
  }

  Widget _buildScrollableTextWith(String text) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        padding: const EdgeInsets.only(left: 10.0, right: 5.0),
        width: 400,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black12,
        ),
        child: SingleChildScrollView(
          controller: _controller,
          child: Text(text),
        ),
      ),
    );
  }


  void _publishMessage(String text) {
    deviceName=_manager.identifier;
    final String message = type+'/'+ deviceName +'/'+ text;
    _manager.publish(message);
  }
}