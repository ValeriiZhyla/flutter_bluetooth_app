import 'package:flutter/material.dart';

import 'menu/rules.dart';
import 'ble_devices/list_of_devices.dart';
import 'menu/home.dart';
import 'menu/start_game.dart';
import 'game/main_game_screen.dart';
import 'key.dart';

const String homeRoute = '/';
const String deviceListRoute = '/list_of_devices';
const String rulesRoute = '/rules';
const String startGameRoute = '/start';
const String gameMainRoute = '/game';

class GameRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case deviceListRoute:
        return MaterialPageRoute(builder: (_) => DeviceList(key: bluetoothKey));
      case rulesRoute:
        return MaterialPageRoute(builder: (_) => const RulesScreen());
      case startGameRoute:
        return MaterialPageRoute(builder: (_) => const StartGameScreen());
      case gameMainRoute:
        return MaterialPageRoute(builder: (_) => const GameMainScreen());

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
