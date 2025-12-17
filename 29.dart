import 'package:flutter/material.dart';

void main() {
  runApp(const OverlayApp());
}

class OverlayApp extends StatelessWidget {
  const OverlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Image Overlay')),
        body: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.network(
                'https://picsum.photos/300/200',
                fit: BoxFit.cover,
              ),
              Container(
                width: 300,
                height: 200,
                color: Colors.black.withOpacity(0.4),
              ),
              const Text(
                'Overlay Text',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
