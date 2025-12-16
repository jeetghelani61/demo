import 'package:flutter/material.dart';

void main() {
  runApp(const CartApp());
}

class CartApp extends StatefulWidget {
  const CartApp({super.key});

  @override
  State<CartApp> createState() => _CartAppState();
}

class _CartAppState extends State<CartApp> {
  int cartCount = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Cart ($cartCount)'),
        ),
        body: ListView(
          children: [
            itemTile('Apple'),
            itemTile('Banana'),
            itemTile('Orange'),
          ],
        ),
      ),
    );
  }

  Widget itemTile(String name) {
    return ListTile(
      title: Text(name),
      trailing: ElevatedButton(
        onPressed: () {
          setState(() {
            cartCount++;
          });
        },
        child: const Text('Add to Cart'),
      ),
    );
  }
}
