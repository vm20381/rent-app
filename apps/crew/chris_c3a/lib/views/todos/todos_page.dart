import 'package:chris_c3a/models/todo_model.dart';
import 'package:chris_c3a/widgets/todos/todos_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/views/layouts/layout.dart';
import '../../controllers/todos/todos_page_controller.dart';
import '../../helpers/widgets/my_spacing.dart';
import '../../widgets/todos/todo_add.dart';

class TodosPage extends StatefulWidget {
  const TodosPage({super.key});

  @override
  _TodosPageState createState() => _TodosPageState();
}

class _TodosPageState extends State<TodosPage> {
  late final TodosPageController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(TodosPageController());
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Todos Page'),
            MySpacing.height(30),

            // AddTodo widget
            AddTodo(),

            MySpacing.height(30),
            // TodosList widget
            const TodosList(),
          ],
        ),
      ),
    );
  }
}
