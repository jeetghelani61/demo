import 'package:flutter/material.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  final List<String> tasks = [];
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('To-Do List')),
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
                  tasks.add(controller.text);
                  controller.clear();
                });
              },
              child: const Text('Add'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(tasks[index]),
                    onDismissed: (direction) {
                      setState(() {
                        tasks.removeAt(index);
                      });
                    },
                    background: Container(color: Colors.red),
                    child: ListTile(
                      title: Text(tasks[index]),
                    ),
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
