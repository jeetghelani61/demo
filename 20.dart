import 'package:flutter/material.dart';

void main() {
  runApp(const TaskApp());
}

class TaskApp extends StatefulWidget {
  const TaskApp({super.key});

  @override
  State<TaskApp> createState() => _TaskAppState();
}

class _TaskAppState extends State<TaskApp> {
  final List<Map<String, dynamic>> tasks = [];
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Task Manager')),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'Add Task',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  tasks.add({'title': controller.text, 'done': false});
                  controller.clear();
                });
              },
              child: const Text('Add'),
            ),
            Expanded(
              child: ListView(
                children: tasks.map((task) {
                  return CheckboxListTile(
                    title: Text(task['title']),
                    value: task['done'],
                    onChanged: (value) {
                      setState(() {
                        task['done'] = value;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
