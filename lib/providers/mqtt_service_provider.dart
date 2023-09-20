import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:balooner/services/mqtt_service.dart';

final mqttManagerProvider = ChangeNotifierProvider<MQTTManager>((ref) {
  return MQTTManager();
});
