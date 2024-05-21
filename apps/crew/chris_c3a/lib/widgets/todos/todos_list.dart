import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/todos/todos_page_controller.dart';
import '../../models/todo_model.dart';
import 'todo_item.dart';

class TodosList extends StatelessWidget {
  const TodosList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TodosPageController>();
    return StreamBuilder<List<Todo>>(
      stream: controller.getTodos(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final todos = snapshot.data!;
        return Center(
          child: Column(
            children: [
              const Text(
                'Your Todos',
                style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
              ),
              Center(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TodoItem(todo: todo),
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
