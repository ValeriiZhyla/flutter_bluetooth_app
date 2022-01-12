import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_app/game/game_config.dart';
import 'package:flutter_bluetooth_app/ble_devices/list_of_devices.dart';

class GameMainScreen extends StatefulWidget {
  const GameMainScreen({Key? key}) : super(key: key);

  @override
  _GameMainScreenState createState() => _GameMainScreenState();
}

class _GameMainScreenState extends State<GameMainScreen> {
  int score = 0;
  double multiplier = 1.0;
  int auto = 0;

  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: secondsBetweenBandChecks), (Timer t) => checkBandForNewSteps());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Game"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Text("Points: $score"),
            ],
          ),
          Row(
            children: [
              Text("Multiplier: $multiplier"),
            ],
          ),
          Row(
            children: [
              Text("Producing: $auto"),
            ],
          ),
        ],
      ),
    );
  }

  checkBandForNewSteps() {
  }


}
