import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/service_locator.dart';
import 'package:balooner/screens/controlls_screen.dart';
import 'package:balooner/screens/settings_screen.dart';
import 'package:balooner/screens/role_selection_screen.dart';
void main() {
  setupLocator();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (BuildContext context) => RoleSelectionScreen(),
          'settings_route': (BuildContext context) => SettingsScreen(),
        });
  }
}
