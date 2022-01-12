import 'package:flutter/material.dart';

class RulesScreen extends StatefulWidget {
  const RulesScreen({Key? key}) : super(key: key);

  @override
  _RulesScreenState createState() => _RulesScreenState();
}

class _RulesScreenState extends State<RulesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Game Rules"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: const [
                  Text(
                    "1. Connect your band",
                    style: TextStyle(fontSize: 28),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.all(30)),

              Row(
                children: const [
                  Text(
                    "2. Run to get points",
                    style: TextStyle(fontSize: 28),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.all(30)),

              Row(
                children: const [
                  Text(
                    "3. Have fun",
                    style: TextStyle(fontSize: 28),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
