import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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

  @override
  void initState() {
    super.initState();
    controller = ToDoListController();
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
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => controller.removeTodoAt(index),
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