import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import '../../controllers/todos/todos_page_controller.dart';
import '../../models/todo_model.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final ValueChanged<bool> onChangedCheckBox;
  final VoidCallback onDelete;

  const TodoItem({
    super.key,
    required this.todo,
    required this.onDelete,
    required this.onChangedCheckBox,
  });

  @override
  Widget build(BuildContext context) {
    // final controller = Get.find<TodosPageController>();
    return ListTile(
      leading: Checkbox(
        value: todo.isDone,
        onChanged: (bool? newValue) => {
          if (newValue != null)
            {
              onChangedCheckBox(newValue),
            },
        },
      ),
      title: Text(todo.title),
      subtitle: Text(todo.description),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: onDelete,
      ),
    );
  }
}
