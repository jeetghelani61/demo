import 'package:flutter/material.dart';

void main() {
  runApp(const SearchApp());
}

class SearchApp extends StatefulWidget {
  const SearchApp({super.key});

  @override
  State<SearchApp> createState() => _SearchAppState();
}

class _SearchAppState extends State<SearchApp> {
  final List<String> names = ['Apple', 'Banana', 'Mango', 'Orange'];
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    final filteredList = names
        .where((item) =>
            item.toLowerCase().contains(searchText.toLowerCase()))
        .toList();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Search')),
        body: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(filteredList[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
