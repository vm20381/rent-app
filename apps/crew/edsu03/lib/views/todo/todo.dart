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
                        controller: TextEditingController(),
                        decoration: const InputDecoration(
                          labelText: 'Enter a todo item',
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => (),//_addTodoItem(_controller.text),
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ),
            ]
          );
        },
      ),
    );
  }
}