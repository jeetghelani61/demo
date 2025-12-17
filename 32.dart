import 'package:flutter/material.dart';

void main() {
  runApp(const CustomButtonApp());
}

class CustomButtonApp extends StatelessWidget {
  const CustomButtonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                width: 160,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  'Upload',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              const Positioned(
                top: -18,
                child: CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: Icon(Icons.cloud_upload, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
