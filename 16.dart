import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const CarouselApp());
}

class CarouselApp extends StatefulWidget {
  const CarouselApp({super.key});

  @override
  State<CarouselApp> createState() => _CarouselAppState();
}

class _CarouselAppState extends State<CarouselApp> {
  final PageController _controller = PageController();
  int currentPage = 0;

  final List<String> images = [
    'https://picsum.photos/400/200?1',
    'https://picsum.photos/400/200?2',
    'https://picsum.photos/400/200?3',
  ];

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (currentPage < images.length - 1) {
        currentPage++;
      } else {
        currentPage = 0;
      }
      _controller.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Image Carousel')),
        body: PageView.builder(
          controller: _controller,
          itemCount: images.length,
          itemBuilder: (context, index) {
            return Image.network(
              images[index],
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }
}
