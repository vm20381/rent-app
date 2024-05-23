import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/todos/todos_page_controller.dart';
import '../../models/todo_model.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;

  const TodoItem({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TodosPageController>();
    return ListTile(
      leading: Checkbox(
        value: todo.isDone,
        onChanged: (bool? newValue) {
          controller.updateTodo(todo.copyWith(isDone: newValue));
        },
      ),
      title: Text(todo.title),
      subtitle: Text(todo.description),
    );
  }
}
