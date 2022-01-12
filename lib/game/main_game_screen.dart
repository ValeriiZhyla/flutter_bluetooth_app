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
  double playerPoints = startingScore;
  double stepMultiplier = startingMultiplier;
  double autoPoints = startingAutoPoints;
  double nitroCoefficient = startingNitroCoefficient;


  Timer? timerSteps;
  Timer? timerAuto;

  List<int> steps = [];
  int firstStepValueInSession = 0;
  bool isFirstValueSet = false;
  bool isNewValueAvailable = false;

  int dopingPrice = startingDopingPrice;
  int roboticLegPrice = startingRoboticLegPrice;
  int nitroPrice = startingNitroPrice;
  int redBullVodkaPrice = startingRedBullVodkaPrice;
  int reachDeadLinePrice = startingReachDeadLinePrice;


  Random random = Random();

  @override
  void initState() {
    super.initState();
    timerSteps = Timer.periodic(const Duration(seconds: secondsBetweenBandChecks), (Timer t) => updateStepsScore());
    timerAuto = Timer.periodic(const Duration(seconds: secondsBetweenAutoScoreIncreases), (Timer t) => updateAutoScore());
  }

  @override
  void dispose() {
    timerSteps?.cancel();
    timerAuto?.cancel();
    super.dispose();
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Points: ${playerPoints.floor()}",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 40.0),
                ),
              ),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Step Multiplier: $stepMultiplier",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Auto Steps: $autoPoints",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
                ),
              )
            ],
          ),
          const Divider(),
          Expanded(
            child: ListTile(
              leading: const Icon(Icons.control_point_rounded),
              title: const Text("Doping"),
              subtitle: Text("$dopingPrice"),
              enabled: hasEnoughPoints(dopingPrice),
              onTap: () => buyDoping(),
              trailing: const Icon(Icons.shopping_cart),
            ),
          ),
          const Divider(),
          Expanded(
            child: ListTile(
              leading: const Icon(Icons.control_point_rounded),
              title: const Text("Robotic leg"),
              subtitle: Text("$roboticLegPrice"),
              enabled: hasEnoughPoints(roboticLegPrice),
              onTap: () => buyRoboticLeg(),
              trailing: const Icon(Icons.shopping_cart),
            ),
          ),
          const Divider(),
          Expanded(
            child: ListTile(
              leading: const Icon(Icons.control_point_rounded),
              title: const Text("Nitro"),
              subtitle: Text("$nitroPrice"),
              enabled: hasEnoughPoints(nitroPrice),
              onTap: () => buyNitro(),
              trailing: const Icon(Icons.shopping_cart),
            ),
          ),
          const Divider(),
          Expanded(
            child: ListTile(
              leading: const Icon(Icons.control_point_rounded),
              title: const Text("Red Bull + Vodka"),
              subtitle: Text("$redBullVodkaPrice"),
              enabled: hasEnoughPoints(redBullVodkaPrice),
              onTap: () => buyRedBullVodka(),
              trailing: const Icon(Icons.shopping_cart),
            ),
          ),
          const Divider(),
          Expanded(
            child: ListTile(
              leading: const Icon(Icons.control_point_rounded),
              title: const Text("Deadline"),
              subtitle: Text("$reachDeadLinePrice"),
              enabled: hasEnoughPoints(reachDeadLinePrice),
              onTap: () => buyDeadline(),
              trailing: const Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
    );
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

  updateStepsScore() {
    fetchDeviceInformation();
    setState(() {
      if (isNewValueAvailable) {
        if (steps.length == 1) {
          playerPoints += max(0, stepMultiplier * steps.last).floor();
        }
        if (steps.length >= 2) {
          playerPoints += max(0, stepMultiplier * (steps[steps.length - 1] - steps[steps.length - 2])).floor();
        }
        isNewValueAvailable = false;
      }
    });
  }

  updateAutoScore() {
    setState(() {
      if (autoPoints > 0) {
        playerPoints += max(0, autoPoints * nitroCoefficient).floor();
      }
    });
  }

  hasEnoughPoints(multiplierIncreasePrice) {
    return playerPoints >= multiplierIncreasePrice;
  }

  double multiplyWithRandomCoefficient(valueToMultiply) {
    double minimum = lowerBoundRandomCoefficient;
    double maximum = upperBoundRandomCoefficient;
    double randomCoefficient = random.nextDouble() * (maximum - minimum) + minimum;
    return valueToMultiply * randomCoefficient;
  }

  buyDoping() {
    setState(() {
      playerPoints -= dopingPrice;
      dopingPrice = multiplyWithRandomCoefficient(dopingPrice).floor();
      stepMultiplier *= dopingMultiplierCoefficient;
    });
  }

  buyRoboticLeg() {
    setState(() {
      playerPoints -= roboticLegPrice;
      roboticLegPrice = multiplyWithRandomCoefficient(roboticLegPrice).floor();
      autoPoints += roboticLegAutoPoints * nitroCoefficient;
    });
  }


  buyNitro() {
    setState(() {
      playerPoints -= nitroPrice;
      nitroPrice = multiplyWithRandomCoefficient(nitroPrice).floor();
      nitroCoefficient *= nitroNitroMultiplierCoefficient;
    });
  }

  buyRedBullVodka() {
    setState(() {
      playerPoints -= redBullVodkaPrice;
      redBullVodkaPrice = multiplyWithRandomCoefficient(redBullVodkaPrice).floor();
      stepMultiplier *= redBullVodkaMultiplierCoefficient;
    });
  }

  buyDeadline() {
    setState(() {
      playerPoints -= reachDeadLinePrice;
      reachDeadLinePrice = multiplyWithRandomCoefficient(reachDeadLinePrice).floor();
      nitroCoefficient *= deadLineNitroMultiplierCoefficient;
    });
  }
}
