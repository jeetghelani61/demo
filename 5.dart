import 'package:flutter/material.dart';

void main() {
  runApp(const RowLayoutApp());
}

class RowLayoutApp extends StatelessWidget {
  const RowLayoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(color: Colors.red),
            ),
            Expanded(
              flex: 2,
              child: Container(color: Colors.green),
            ),
            Expanded(
              flex: 1,
              child: Container(color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
