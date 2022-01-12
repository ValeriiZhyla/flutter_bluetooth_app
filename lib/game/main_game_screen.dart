import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_bluetooth_app/game/game_config.dart';
import 'package:flutter_bluetooth_app/ble_devices/list_of_devices.dart';
import 'package:flutter_bluetooth_app/key.dart';

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

  List<int> steps = [];
  int firstStepValueInSession = 0;
  bool isFirstValueSet = false;
  bool newValuesAvailable = false;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: secondsBetweenBandChecks), (Timer t) => readNewValuesFromDevice());
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


  Future<List<int>> _fetchStepCharacteristic() async {
    BluetoothCharacteristic? characteristic = bluetoothKey.currentState?.getStepCharacteristic();
    if (characteristic == null) {
      throw Exception("Device Error");
    }
    var sub = characteristic.value.listen((value) {
      setState(() {
        int stepsCount = value[1];
        if (!isFirstValueSet && stepsCount > 0) {
          firstStepValueInSession = stepsCount;
        }
        print(stepsCount);
        steps.add(stepsCount);
        newValuesAvailable = true;
      });
    });
    await characteristic.read();
    return characteristic.read();
  }

  int readNewValuesFromDevice() {
    _fetchStepCharacteristic();
    newValuesAvailable = false;
    return steps.last - firstStepValueInSession;
  }

}
