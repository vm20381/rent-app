import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:pilipb/controllers/todo/todo_page_controller.dart';
import 'package:pilipb/views/layouts/layout.dart';
import 'package:pilipb/models/todo.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({Key? key}) : super(key: key);

  @override
  _ToDoListPageState createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  late ToDoListController controller;
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _editTextController = TextEditingController();
  Image? _imagePreview;
  Uint8List? imageBytes;  // Declare imageBytes at class level

  @override
  void initState() {
    super.initState();
    controller = ToDoListController();
  }

  Future<Uint8List?> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      try {
        final bytes = await pickedFile.readAsBytes();
        final base64Image = base64Encode(bytes);
        final image = Image.memory(base64Decode(base64Image));

        setState(() {
          _imagePreview = image;
        });

        // Pass the bytes to the controller method, now optionally
        return bytes;
        // controller.addTodo("Your task description", bytes);
      } catch (e) {
        print('Failed to load image: $e');
      }
    } else {
      print('No image selected.');
      imageBytes = null;  // Ensure imageBytes is null if no image is picked
    }
  }

  void _showEditDialog(String id) {
    var todo = controller.todos.firstWhere((t) => t.id == id);
    if (todo == null) {
      print('Todo with id $id not found');
      return; // Exit if no todo found with the given id
    }
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
                  controller.editTodo(id, _editTextController.text);
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
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          decoration: InputDecoration(
                            labelText: 'Add a new to-do',
                            border: OutlineInputBorder(),
                          ),
                          onSubmitted: (value) {
                            if (value.isNotEmpty) {
                              controller.addTodo(value, imageBytes); // Use imageBytes conditionally
                              _textController.clear();
                              setState(() {
                                _imagePreview = null;
                                imageBytes = null; // Set imageBytes back to null
                              });
                            }
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: () async {
                          imageBytes = await _pickImage();
                        },
                      ),
                      if (_imagePreview != null)
                        Container(
                          width: 50,
                          height: 50,
                          margin: EdgeInsets.only(left: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: _imagePreview,
                          ),
                        ),
                    ],
                  ),
                ),
                Obx(() {
                  // Sort todos by date added in descending order
                  var sortedTodos = List<ToDo>.from(controller.todos)..sort((a, b) => b.dateAdded.compareTo(a.dateAdded));

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: sortedTodos.length,
                    itemBuilder: (context, index) {
                      var todo = sortedTodos[index];
                      Widget leadingWidget = Checkbox(
                        value: todo.isDone,
                        onChanged: (bool? value) {
                          if (value != null) {
                            controller.toggleDone(todo.id);
                          }
                        },
                      );

                      // Check if the todo item has an image and create a thumbnail
                      if (todo.imageUrl != null && todo.imageUrl!.isNotEmpty) {
                        leadingWidget = Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // show the image as a thumbnail
                            Image.network(
                              todo.imageUrl!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            leadingWidget, // Checkbox
                          ],
                        );
                      } else {
                        // Display a default logo when there is no image
                        leadingWidget = Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Opacity(
                              opacity: 0.2,
                              child: Icon(
                                // insert camera icon
                                LucideIcons.camera,
                                size: 50,
                                
                              ),
                            ),
                            leadingWidget, // Checkbox
                          ],
                        );
                      }

                      return ListTile(
                        leading: leadingWidget,
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
                              onPressed: () => _showEditDialog(todo.id),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                              
                                controller.removeTodoAt(todo.id);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.download),
                              onPressed: todo.imageUrl != null && todo.imageUrl!.isNotEmpty
                                ? () {
                                    // go to url in new tab
                                    window.open(todo.imageUrl!, 'download');
                                  }
                                : null, // Disables the button when imageUrl is null or empty
                              color: todo.imageUrl != null && todo.imageUrl!.isNotEmpty ? null : Colors.grey,
                            ),
                          ],
                        ),
                        onTap: () {
                          if (todo.imageUrl != null && todo.imageUrl!.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImageDetailScreen(imageUrl: todo.imageUrl!),
                              ),
                            );
                          }
                        },
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

class ImageDetailScreen extends StatelessWidget {
  final String imageUrl;

  ImageDetailScreen({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Detail'),
      ),
      body: Center(
        child: Image.network(
          imageUrl,
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
            return Text('Image not available');
          },
        ),
      ),
    );
  }
}
