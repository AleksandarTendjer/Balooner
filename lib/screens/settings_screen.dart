import 'package:balooner/helpers/random_generator.dart';
import 'package:balooner/models/mqtt_app_state.dart';
import 'package:balooner/providers/mqtt_service_provider.dart';
import 'package:balooner/services/database_service.dart';
import 'package:balooner/services/mqtt_service.dart';
import 'package:balooner/widgets/status_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final TextEditingController _textTextController = TextEditingController();
  late MQTTManager _manager;
  final TextEditingController _hostTextController = TextEditingController();
  late DatabaseService _databaseService = DatabaseService();
  late String deviceId;
  late String _documentId;

  @override
  Widget build(BuildContext context) {
    _manager = ref.watch(mqttManagerProvider);

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
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
          )
        ]);  }

    Widget _buildColumn(MQTTManager manager) {
      return Column(
        children: <Widget>[
          StatusBar(
              statusMessage: prepareStateMessageFrom(
                  manager.currentState.getAppConnectionState)),
          _buildEditableColumn(manager.currentState),
        ],
      );
    }
  Widget _buildEditableColumn(MQTTAppState currentAppState) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          _buildTextFieldWith(_hostTextController, 'Enter broker address',
              currentAppState.getAppConnectionState),
          const SizedBox(height: 10),
          _buildConnecteButtonFrom(currentAppState.getAppConnectionState)
        ],
      ),
    );
  }

  Widget _buildTextFieldWith(TextEditingController controller, String hintText,
      MQTTAppConnectionState state) {
    bool shouldEnable = false;
    if ((controller == _hostTextController &&
        state == MQTTAppConnectionState.disconnected)) {
      shouldEnable = true;
    } else if (controller == _hostTextController && _manager.host != null) {
      _hostTextController.text = _manager.host!;
    }
    return TextField(
        enabled: shouldEnable,
        controller: controller,
        decoration: InputDecoration(
          contentPadding:
          const EdgeInsets.only(left: 0, bottom: 0, top: 0, right: 0),
          labelText: hintText,
        ));
  }

  Widget _buildConnecteButtonFrom(MQTTAppConnectionState state) {
    return Row(
      children: <Widget>[
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent),
            child: const Text('Connect'),
            onPressed: state == MQTTAppConnectionState.disconnected
                ? _configureAndConnect
                : null, //
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Disconnect'),
            onPressed: state != MQTTAppConnectionState.disconnected
                ? _disconnect
                : null, //
          ),
        ),
      ],
    );
  }

  void _configureAndConnect() {
    String id = 'device_' + RandomGenerator.md5RandomString();
    deviceId = id;
    _manager.initializeMQTTClient(
        host: _hostTextController.text, identifier: id);
    _manager.connect();
    Map<String, dynamic> data = {
      "deviceName": id,
    };
    _databaseService
        .createDocument("ConnectedDevice", data)
        .then((docRef) => {_documentId = docRef.id})
        .catchError((error) {
      print("Error creating document: $error");
    });
  }

  void _disconnect() {
    _databaseService
        .deleteDocument("connectedDevice", _documentId)
        .whenComplete(() => {_manager.disconnect()})
        .catchError((error) {
      print("Error deleting document: $error");
    });
  }
}
