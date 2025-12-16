import 'package:flutter/material.dart';

void main() {
  runApp(const SwitchApp());
}

class SwitchApp extends StatefulWidget {
  const SwitchApp({super.key});

  @override
  State<SwitchApp> createState() => _SwitchAppState();
}

class _SwitchAppState extends State<SwitchApp> {
  bool isOn = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: isOn ? Colors.lightBlue : Colors.white,
        appBar: AppBar(title: const Text('Toggle Switch')),
        body: Center(
          child: Switch(
            value: isOn,
            onChanged: (value) {
              setState(() {
                isOn = value;
              });
            },
          ),
        ),
      ),
    );
  }
}
