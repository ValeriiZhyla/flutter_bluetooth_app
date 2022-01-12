import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_app/home.dart';
import 'package:flutter_bluetooth_app/list_of_devices.dart';
import 'package:flutter_bluetooth_app/router.dart';

void main() => runApp(const GameApp());

class GameApp extends StatelessWidget {
  const GameApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      onGenerateRoute: GameRouter.generateRoute,
      initialRoute: homeRoute,
    );
  }
}
