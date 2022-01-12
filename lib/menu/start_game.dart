import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_app/router.dart';

class StartGameScreen extends StatelessWidget {
  const StartGameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Start Game"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, gameMainRoute);
                },
                child: const Text("New Game"),
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 28),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                ),
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.all(30)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  null;
                },
                child: const Text("Continue"),
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 28),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
