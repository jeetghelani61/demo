import 'package:flutter/material.dart';

void main() {
  runApp(const CustomListApp());
}

class CustomListApp extends StatefulWidget {
  const CustomListApp({super.key});

  @override
  State<CustomListApp> createState() => _CustomListAppState();
}

class _CustomListAppState extends State<CustomListApp> {
  List<String> items = ['Apple', 'Banana', 'Mango'];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Custom List')),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: Text(items[index]),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    items.removeAt(index);
                  });
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
