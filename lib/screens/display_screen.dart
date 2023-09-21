import 'dart:io';
import 'package:flutter/material.dart';
import 'package:balooner/services/mqtt_service.dart';
import 'package:balooner/models/mqtt_app_state.dart';
import 'package:balooner/widgets/status_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:balooner/providers/mqtt_service_provider.dart';

class DisplayScreen extends ConsumerStatefulWidget {
  const DisplayScreen({Key? key}) : super(key: key);

  @override
  _DisplayScreenState createState() => _DisplayScreenState();
}

class _DisplayScreenState extends ConsumerState<DisplayScreen> {
  final TextEditingController _topicTextController = TextEditingController();
  final _controller = ScrollController();
  late MQTTManager _manager;
  late BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _manager = ref.watch(mqttManagerProvider);
    _context = context;
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
          _buildTopicSubscribeRow(currentAppState),
          const SizedBox(height: 10),
          _buildScrollableTextWith(currentAppState.getHistoryText),
        ],
      ),
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

  Widget _buildTextFieldWith(TextEditingController controller, String hintText,
      MQTTAppConnectionState state) {
    bool shouldEnable = false;
    if (controller == _topicTextController &&
        (state == MQTTAppConnectionState.connected ||
            state == MQTTAppConnectionState.connectedUnSubscribed)) {
      shouldEnable = true;
    }
    return TextField(
      enabled: shouldEnable,
      controller: controller,
      decoration: InputDecoration(
        contentPadding:
        const EdgeInsets.only(left: 0, bottom: 0, top: 0, right: 0),
        labelText: hintText,
      ),
    );
  }

  Widget _buildTopicSubscribeRow(MQTTAppState currentAppState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          child: _buildTextFieldWith(
            _topicTextController,
            'Enter a topic to subscribe or listen',
            currentAppState.getAppConnectionState,
          ),
        ),
        _buildSubscribeButtonFrom(currentAppState.getAppConnectionState),
      ],
    );
  }

  Widget _buildSubscribeButtonFrom(MQTTAppConnectionState state) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        disabledForegroundColor: Colors.grey,
        disabledBackgroundColor: Colors.black38.withOpacity(0.12),
      ),
      onPressed: (state == MQTTAppConnectionState.connectedSubscribed) ||
          (state == MQTTAppConnectionState.connectedUnSubscribed) ||
          (state == MQTTAppConnectionState.connected)
          ? () {
        _handleSubscribePress(state);
      }
          : null,
      child: state == MQTTAppConnectionState.connectedSubscribed
          ? const Text('Unsubscribe')
          : const Text('Subscribe'),
    );
  }
  void _handleSubscribePress(MQTTAppConnectionState state) {
    if (state == MQTTAppConnectionState.connectedSubscribed) {
      _manager.unSubscribeFromCurrentTopic();
    } else {
      String enteredText = _topicTextController.text;
      if (enteredText != null && enteredText.isNotEmpty) {
        _manager.subScribeTo(_topicTextController.text);
      }
    }
  }

}
