import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenboi123/controllers/to_do_list/to_do_list_controller.dart';
import 'package:greenboi123/models/to_do_list_model.dart';
import 'package:greenboi123/views/layouts/layout.dart';

class ToDoList extends StatelessWidget {
  final ToDoController _myController = Get.put(ToDoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Layout(
        child: StreamBuilder<List<TodoItem>>(
          stream: _myController.myCollectionStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            final todoItems = snapshot.data ?? [];

            return Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _showAddTodoDialog(context);
                    },
                    child: const Text('Add To-Do Item'),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: todoItems.length,
                      itemBuilder: (context, index) {
                        final todoItem = todoItems[index];
                        final textStyle = todoItem.isDone
                            ? const TextStyle(
                                decoration: TextDecoration.lineThrough,
                              )
                            : const TextStyle();

                        return Material(
                          child: ListTile(
                            title: Text(
                              todoItem.title,
                              style: textStyle,
                            ),
                            subtitle: Text(
                              todoItem.description,
                              style: textStyle,
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value: todoItem.isDone,
                                  onChanged: (bool? value) {
                                    final updatedItem = TodoItem(
                                      id: todoItem.id,
                                      title: todoItem.title,
                                      description: todoItem.description,
                                      isDone: value ?? false,
                                    );
                                    _myController.updateTodoItem(updatedItem);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    _showEditTodoDialog(context, todoItem);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    _myController.deleteTodoItem(todoItem.id);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add To-Do Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                final title = titleController.text;
                final description = descriptionController.text;
                if (title.isNotEmpty && description.isNotEmpty) {
                  final newItem = TodoItem(
                    id: DateTime.now().toString(), // Generate a unique ID
                    title: title,
                    description: description,
                    isDone: false,
                  );
                  _myController.addTodoItem(newItem);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditTodoDialog(BuildContext context, TodoItem todoItem) {
    final titleController = TextEditingController(text: todoItem.title);
    final descriptionController = TextEditingController(text: todoItem.description);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit To-Do Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                final title = titleController.text;
                final description = descriptionController.text;
                if (title.isNotEmpty && description.isNotEmpty) {
                  final updatedItem = TodoItem(
                    id: todoItem.id,
                    title: title,
                    description: description,
                    isDone: todoItem.isDone,
                  );
                  _myController.updateTodoItem(updatedItem);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}



