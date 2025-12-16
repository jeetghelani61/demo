flutter:
  assets:
    - assets/images/sample.jpg

import 'package:flutter/material.dart';

void main() {
  runApp(const AssetImageApp());
}

class AssetImageApp extends StatelessWidget {
  const AssetImageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Asset Image')),
        body: Column(
          children: [
            Image.asset(
              'assets/images/sample.jpg',
              height: 150,
              fit: BoxFit.cover,
            ),
            Image.asset(
              'assets/images/sample.jpg',
              height: 150,
              fit: BoxFit.contain,
            ),
            Image.asset(
              'assets/images/sample.jpg',
              height: 150,
              fit: BoxFit.fill,
            ),
          ],
        ),
      ),
    );
  }
}     
