enum MQTTAppConnectionState { connected, disconnected, connecting, connectedSubscribed,subscribing, connectedUnSubscribed }
String prepareStateMessageFrom(MQTTAppConnectionState state) {
  switch (state) {
    case MQTTAppConnectionState.connected:
      return 'Connected';
    case MQTTAppConnectionState.connecting:
      return 'Connecting';
    case MQTTAppConnectionState.disconnected:
      return 'Disconnected';
    case MQTTAppConnectionState.connectedSubscribed:
      return 'Subscribed';
    case MQTTAppConnectionState.subscribing:
      return 'subscribing';
    case MQTTAppConnectionState.connectedUnSubscribed:
      return 'Unsubscribed';
  }
}
class MQTTAppState{
  MQTTAppConnectionState _appConnectionState = MQTTAppConnectionState.disconnected;

  MQTTAppConnectionState get appConnectionState => _appConnectionState;
  String _receivedCommand = '';
  String _historyCommand = '';


  void setReceivedCommand(String command) {
    _receivedCommand = command;
    _historyCommand = _historyCommand + '\n' + _receivedCommand;
  }
  void setAppConnectionState(MQTTAppConnectionState state) {
    _appConnectionState = state;
  }

  void clearText() {
    _receivedCommand = "";
  }

  String prepareStateMessageFrom(MQTTAppConnectionState state) {
    switch (state) {
      case MQTTAppConnectionState.connected:
        return 'Connected';
      case MQTTAppConnectionState.connecting:
        return 'Connecting';
      case MQTTAppConnectionState.disconnected:
        return 'Disconnected';
      case MQTTAppConnectionState.connectedSubscribed:
        return 'Subscribed';
      case MQTTAppConnectionState.subscribing:
        return 'subscribing';
      case MQTTAppConnectionState.connectedUnSubscribed:
        return 'Unsubscribed';
    }
  }
  String get getReceivedText => _receivedCommand;
  String get getHistoryText => _historyCommand;
  MQTTAppConnectionState get getAppConnectionState => _appConnectionState;

}