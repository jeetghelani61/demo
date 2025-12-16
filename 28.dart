import 'package:flutter/material.dart';

void main() {
  runApp(const ProductApp());
}

class ProductApp extends StatelessWidget {
  const ProductApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Products')),
        body: SizedBox(
          height: 220,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              productCard('Phone', '₹20000'),
              productCard('Laptop', '₹50000'),
              productCard('Headset', '₹3000'),
            ],
          ),
        ),
      ),
    );
  }

  Widget productCard(String name, String price) {
    return Container(
      width: 160,
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          Image.network(
            'https://picsum.photos/200',
            height: 120,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 5),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(price),
        ],
      ),
    );
  }
}
