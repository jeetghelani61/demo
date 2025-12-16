import 'package:flutter/material.dart';

void main() {
  runApp(const ListApp());
}

class ListApp extends StatelessWidget {
  const ListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: NameListScreen(),
    );
  }
}

class NameListScreen extends StatelessWidget {
  const NameListScreen({super.key});

  final List<String> names = const [
    'Amit',
    'Rahul',
    'Priya',
    'Neha',
    'Karan',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Name List')),
      body: ListView.builder(
        itemCount: names.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(names[index]),
            onTap: () {
              print('Name tapped');
            },
          );
        },
      ),
    );
  }
}
