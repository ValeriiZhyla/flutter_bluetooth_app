import 'package:flutter/material.dart';
import '../router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, deviceListRoute);
                },
                child: const Text("Connect to band"),
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
                  Navigator.pushNamed(context, rulesRoute);
                },
                child: const Text("Show rules"),
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
