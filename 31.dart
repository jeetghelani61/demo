import 'package:flutter/material.dart';

void main() {
  runApp(const CardFabApp());
}

class CardFabApp extends StatelessWidget {
  const CardFabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Stack(
            children: [
              Container(
                width: 300,
                height: 180,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 5,
                      color: Colors.grey,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'This is a card UI',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: FloatingActionButton(
                  mini: true,
                  onPressed: () {},
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
