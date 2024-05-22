import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:macieeej/controllers/todo/todo_controller.dart';
import '/views/layouts/layout.dart';

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({Key? key}) : super(key: key);

  @override
  _ToDoListPageState createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  late ToDoListController controller;
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _editTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = ToDoListController();
  }

  void _showEditDialog(int index) {
    if (index < 0 || index >= controller.todos.length) {
      return; // Prevents out-of-bounds access
    }
    var todo = controller.todos[index];
    _editTextController.text = todo.task;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit To-Do"),
          content: TextField(
            controller: _editTextController,
            decoration: InputDecoration(
              labelText: 'To-Do',
              border: OutlineInputBorder(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Save"),
              onPressed: () {
                if (_editTextController.text.isNotEmpty) {
                  controller.editTodo(index, _editTextController.text);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: GetBuilder<ToDoListController>(
        init: controller,
        builder: (controller) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      labelText: 'Add a new to-do',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        controller.addTodo(value);
                        _textController.clear();
                      }
                    },
                  ),
                ),
                Obx(() {
                  if (controller.todos.isEmpty) {
                    return Center(child: Text('No to-dos available.'));
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: controller.todos.length,
                    itemBuilder: (context, index) {
                      var todo = controller.todos[index];
                      return ListTile(
                        leading: Checkbox(
                          value: todo.isDone,
                          onChanged: (bool? value) {
                            if (value != null) {
                              controller.toggleDone(index);
                            }
                          },
                        ),
                        title: Text(
                          todo.task,
                          style: TextStyle(
                            decoration: todo.isDone
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        subtitle: Text('Created by: ${todo.userName}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => _showEditDialog(index),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => controller.removeTodoAt(index),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}