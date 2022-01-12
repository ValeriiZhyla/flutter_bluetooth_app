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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, gameMainRoute);
                    },
                    child: const Text("Start a New Game"),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      null;
                    },
                    child: const Text("Continue"),
                  ),
                ],
              ),
            ])
          ],
        ));
  }
}
