import 'package:flutter/material.dart';

void main() {
  runApp(const ProfileStackApp());
}

class ProfileStackApp extends StatelessWidget {
  const ProfileStackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: 200,
              color: Colors.blue,
            ),
            Positioned(
              top: 120,
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      'https://picsum.photos/200',
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'John Doe',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('Flutter Developer'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
