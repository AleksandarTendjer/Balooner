import 'package:balooner/models/mqtt_app_state.dart';
import 'package:balooner/providers/mqtt_service_provider.dart';
import 'package:balooner/screens/controlls_screen.dart';
import 'package:balooner/screens/display_screen.dart';
import 'package:balooner/services/mqtt_service.dart'; // Import your MQTT service file
import 'package:balooner/widgets/status_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoleSelectionScreen extends ConsumerStatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  @override
  ConsumerState<RoleSelectionScreen> createState() =>
      _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends ConsumerState<RoleSelectionScreen> {
  final _controller = ScrollController();
  late MQTTManager _manager;
  final TextEditingController _topicTextController = TextEditingController();
  bool isControllerRowVisible = false;
  bool isDisplayRowVisible = false;

  @override
  Widget build(BuildContext context) {
    _manager = ref.watch(mqttManagerProvider);
    if (_controller.hasClients) {
      _controller.jumpTo(_controller.position.maxScrollExtent);
    }

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('./assets/images/background.png'),
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
              _buildPredefinedButton(
                  'Controller', 'controller', currentAppState),
            ],
          ),
          Visibility(
            visible: isControllerRowVisible,
            child: _buildTopicSubscribeRow(currentAppState, 'controller'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildPredefinedButton('Display', 'display', currentAppState),
            ],
          ),
          Visibility(
            visible: isDisplayRowVisible,
            child: _buildTopicSubscribeRow(currentAppState, 'display'),
          )
        ],
      ),
    );
  }

  Widget _buildTopicSubscribeRow(
      MQTTAppState currentAppState, String roleType) {
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
        _buildSubscribeButtonFrom(
            currentAppState.getAppConnectionState, roleType),
      ],
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

  Widget _buildSubscribeButtonFrom(
      MQTTAppConnectionState state, String roleType) {
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
              handleSubscribeAndNavigate(roleType);
            }
          : null,
      child: state == MQTTAppConnectionState.connectedSubscribed
          ? const Text('Unsubscribe')
          : const Text('Subscribe'),
    );
  }

  Widget _buildPredefinedButton(
      String buttonText, String predefinedText, MQTTAppState currentAppState) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.green,
          disabledForegroundColor: Colors.black38.withOpacity(0.38),
          disabledBackgroundColor: Colors.black38.withOpacity(0.12),
          textStyle: TextStyle(color: Colors.white),
        ),
        child: Text(buttonText),
        onPressed: currentAppState.getAppConnectionState ==
                MQTTAppConnectionState.connected
            ? () {
                if (predefinedText == 'controller') {
                  setState(() {
                    isControllerRowVisible = !isControllerRowVisible;
                  });
                  isDisplayRowVisible = false; // Hide the Display row
                } else if (predefinedText == 'display') {
                  setState(() {
                    isDisplayRowVisible = !isDisplayRowVisible;
                  });
                  isControllerRowVisible = false; // Hide the Controller row
                }
              }
            : null);
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

  // Add a method to handle subscription and navigation
  void handleSubscribeAndNavigate(String screenName) {
    if (_manager.currentState.appConnectionState ==
        MQTTAppConnectionState.connectedSubscribed) {
      _manager.unSubscribeFromCurrentTopic();
    } else {
      String enteredText = _topicTextController.text;
      if (enteredText != null && enteredText.isNotEmpty) {
        _manager.subScribeTo(_topicTextController.text);
      }
      // Navigate based on screenName
      _navigateToScreen(screenName);
    }
  }
}
