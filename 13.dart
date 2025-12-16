import 'package:flutter/material.dart';

void main() {
  runApp(const ImageChangeApp());
}

class ImageChangeApp extends StatefulWidget {
  const ImageChangeApp({super.key});

  @override
  State<ImageChangeApp> createState() => _ImageChangeAppState();
}

class _ImageChangeAppState extends State<ImageChangeApp> {
  String imageUrl = 'https://picsum.photos/300/200';

  void changeImage() {
    setState(() {
      imageUrl = 'https://picsum.photos/300/200?random=${DateTime.now()}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Network Image')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(imageUrl),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: changeImage,
              child: const Text('Change Image'),
            ),
          ],
        ),
      ),
    );
  }
}
