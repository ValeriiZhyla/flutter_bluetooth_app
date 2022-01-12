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
        body: Row(
          children: [
            Column(children: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, gameMainRoute);
                  },
                  child: const Text("Start a New Game"),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    null;
                  },
                  child: const Text("Continue"),
                ),
              ),
            ])
          ],
        ));
  }
}
