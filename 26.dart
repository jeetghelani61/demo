import 'package:flutter/material.dart';

void main() {
  runApp(const InfiniteListApp());
}

class InfiniteListApp extends StatefulWidget {
  const InfiniteListApp({super.key});

  @override
  State<InfiniteListApp> createState() => _InfiniteListAppState();
}

class _InfiniteListAppState extends State<InfiniteListApp> {
  List<int> items = List.generate(20, (i) => i);
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (controller.position.pixels ==
          controller.position.maxScrollExtent) {
        loadMore();
      }
    });
  }

  void loadMore() {
    setState(() {
      items.addAll(
        List.generate(10, (i) => items.length + i),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Infinite Scroll')),
        body: ListView.builder(
          controller: controller,
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('Item ${items[index]}'),
            );
          },
        ),
      ),
    );
  }
}
