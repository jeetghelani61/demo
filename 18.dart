import 'package:flutter/material.dart';

void main() {
  runApp(const FeedbackApp());
}

class FeedbackApp extends StatefulWidget {
  const FeedbackApp({super.key});

  @override
  State<FeedbackApp> createState() => _FeedbackAppState();
}

class _FeedbackAppState extends State<FeedbackApp> {
  String selectedCategory = 'App UI';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Feedback')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const TextField(
                decoration: InputDecoration(labelText: 'Name'),
              ),
              const TextField(
                decoration: InputDecoration(labelText: 'Comments'),
              ),
              const SizedBox(height: 15),
              DropdownButton<String>(
                value: selectedCategory,
                items: const [
                  DropdownMenuItem(value: 'App UI', child: Text('App UI')),
                  DropdownMenuItem(value: 'Performance', child: Text('Performance')),
                  DropdownMenuItem(value: 'Bug', child: Text('Bug')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  print('Feedback Submitted');
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
