import 'package:flutter/material.dart';
import 'package:balooner/services/mqtt_service.dart'; // Import your MQTT service file
import 'package:balooner/screens/controlls_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:balooner/providers/mqtt_service_provider.dart';
import 'package:balooner/models/mqtt_app_state.dart';
import 'package:balooner/screens/display_screen.dart';
import 'package:balooner/widgets/status_bar.dart';
class RoleSelectionScreen extends ConsumerStatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  @override
  ConsumerState<RoleSelectionScreen> createState()  => _RoleSelectionScreenState();

}

class _RoleSelectionScreenState extends ConsumerState<RoleSelectionScreen> {
  final _controller = ScrollController();
  late MQTTManager _manager;
  late BuildContext _context;
  @override
  Widget build(BuildContext context) {
    _manager = ref.watch(mqttManagerProvider);
    _context=context;
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
      Row(
      mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildPredefinedButton('Controller', 'controller',currentAppState),
        ],
      ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildPredefinedButton('Display', 'display',currentAppState),
            ],
          ),
        ],
      ),
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
        onPressed:  currentAppState.getAppConnectionState == MQTTAppConnectionState.connected
            ? () {
          _navigateToScreen(predefinedText);
        }   : null
    );
  }
  void _navigateToScreen(String screenName) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          if (screenName == 'display') {
            return DisplayScreen();
          } else if (screenName == 'controller') {
            return ControllsScreen();
          } else {
            return Container();
          }
        },
      ),
    );
  }

}
