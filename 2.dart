import 'package:flutter/material.dart';

void main() {
  runApp(const CounterApp());
}

class CounterApp extends StatefulWidget {
  const CounterApp({super.key});

  @override
  State<CounterApp> createState() => _CounterAppState();
}

class _CounterAppState extends State<CounterApp> {
  int count = 0;

  void incrementCounter() {
    setState(() {
      count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Counter App'),
        ),
        body: Center(
          child: Text(
            'Count: $count',
            style: const TextStyle(fontSize: 28),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: incrementCounter,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
