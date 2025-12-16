import 'package:flutter/material.dart';

void main() {
  runApp(const GridApp());
}

class GridApp extends StatelessWidget {
  const GridApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Image Grid')),
        body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
          ),
          itemCount: 12,
          itemBuilder: (context, index) {
            return Image.network(
              'https://picsum.photos/200?image=$index',
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }
}
