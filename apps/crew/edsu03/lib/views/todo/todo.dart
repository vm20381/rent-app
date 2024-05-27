import 'package:edsu03/controllers/todo/todo_controller.dart';
import 'package:edsu03/helpers/widgets/my_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/views/layouts/layout.dart';
import '../../controllers/new_page/new_page_controller.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({Key? key}) : super(key: key);

  @override
  _ToDoPageState createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  late ToDoPageController controller;
  final TextEditingController todoTextController = TextEditingController();
  @override
  void initState() {
    super.initState();
    controller = ToDoPageController();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: GetBuilder<ToDoPageController>(
        init: controller, //todoController
        builder: (controller) {
              return Column(
                children: [
                  Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: todoTextController,
                        decoration: const InputDecoration(
                          labelText: 'Enter a todo item',
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => {
                        if (todoTextController.text.isNotEmpty) {
                          controller.addTodo(todoTextController.text, ''),
                          todoTextController.clear(),
                        }
                      },
                      child: const Text('Add'),
                    ),
                        
                  ],
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
                        checkColor: Colors.white,
                        activeColor: Colors.green,
                        value: todo.isDone,
                        onChanged: (bool? value) {
                          if (value != null) {
                            controller.toggleDone(index);
                          }
                        },

                      ),
                      title: Text(
                        todo.title,
                        style: TextStyle(
                          decoration: todo.isDone
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      //subtitle: const Text('created by'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => controller.editTodo(),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => controller.removeTodo(index),
      

                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ]
          );
        },
      ),
    );
  }
}