import 'dart:async';
import 'dart:math';

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
  bool isNewValueAvailable = false;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: secondsBetweenBandChecks), (Timer t) => updateStepsScore());
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

  updateStepsScore() {
    fetchDeviceInformation();
    setState(() {
      if (isNewValueAvailable) {
        if (steps.length == 1) {
          score += max(0, multiplier * steps.last).floor();
        }
        if (steps.length >= 2) {
          score += max(0, multiplier * (steps[steps.length - 1] - steps[steps.length - 2])).floor();
        }
        isNewValueAvailable = false;
      }
    });
  }

  Future<List<int>> fetchDeviceInformation() async {
    BluetoothCharacteristic? characteristic = bluetoothKey.currentState?.getStepCharacteristic();
    if (characteristic == null) {
      throw Exception("Device Error");
    }
    var sub = characteristic.value.listen((value) {
      setState(() {
        int stepsCount = value[1];
        if (!isFirstValueSet && stepsCount > 0) {
          firstStepValueInSession = stepsCount;
          isFirstValueSet = true;
        }
        if (isFirstValueSet) {
          stepsCount -= firstStepValueInSession;
        }
        if (steps.isEmpty) {
          steps.add(stepsCount);
          isNewValueAvailable = true;
        } else if (steps.last != stepsCount) {
          steps.add(stepsCount);
          isNewValueAvailable = true;
        }
      });
    });
    await characteristic.read();
    return characteristic.read();
  }
}
