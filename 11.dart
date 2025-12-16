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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Counter')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Count: $count', style: const TextStyle(fontSize: 30)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      count--;
                    });
                  },
                  child: const Text('-'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      count++;
                    });
                  },
                  child: const Text('+'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
