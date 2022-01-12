import 'package:flutter/material.dart';
import 'router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
        ),
        body: Row(
          children: [
            Column(children: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, deviceListRoute);
                  },
                  child: const Text("Connect to band"),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, rulesRoute);
                  },
                  child: const Text("Show rules"),
                ),
              ),
            ])
          ],
        ));
  }
}
