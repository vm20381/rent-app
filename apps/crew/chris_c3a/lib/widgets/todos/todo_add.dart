import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/todos/todos_page_controller.dart';
import '../../models/todo_model.dart';

class AddTodo extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  AddTodo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ElevatedButton(
          onPressed: () => _showAddTaskDialog(context),
          child: const Text('Add Todo'),
        ),
      ],
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Todo'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _titleController,
                  decoration:
                      const InputDecoration(hintText: "Enter task title"),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration:
                      const InputDecoration(hintText: "Enter task description"),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                _addTaskToFirebase();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _addTaskToFirebase() {
    if (_titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty) {
      TodosPageController().addTodo(
        Todo(
            title: _titleController.text,
            description: _descriptionController.text),
      );
    }
  }
}
