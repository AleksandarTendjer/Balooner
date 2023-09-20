
import 'package:balooner/services/mqtt_service.dart';
import 'package:get_it/get_it.dart';
GetIt service_locator = GetIt.instance;
void setupLocator() {
  service_locator.registerLazySingleton(() => MQTTManager());
}