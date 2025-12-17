import 'package:flutter/material.dart';

void main() {
  runApp(const FadeImageApp());
}

class FadeImageApp extends StatelessWidget {
  const FadeImageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: FadeInImage(
            placeholder: AssetImage('assets/placeholder.png'),
            image: NetworkImage('https://picsum.photos/300'),
            width: 300,
          ),
        ),
      ),
    );
  }
}
