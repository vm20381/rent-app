import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pilipb/helpers/services/auth_services.dart';
import 'package:pilipb/helpers/services/firebase_subscription_services.dart';
import 'package:pilipb/models/todo.dart';
import 'package:pilipb/views/home/home_page.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class ToDoListController extends GetxController {
  var todos = <ToDo>[].obs;
  final AuthService authService = Get.find<AuthService>();
  final FirestoreSubscriptionService _firestoreSubService =
      Get.find<FirestoreSubscriptionService>();

  @override
  void onInit() {
    super.onInit();
    _subscribeToTodoItems();
  }

  void _subscribeToTodoItems() {
    _firestoreSubService
        .collectionStream<ToDo>(
      'pb_todo',
      (data, documentId) => ToDo.fromFirestore(data, documentId),
    )
        .listen((todoItems) {
      todos.value = todoItems;
    });
  }

  Future<Reference> prepareImageUpload(Uint8List imageData) async {
    if (imageData.isNotEmpty) {
      print("Image data is prepared for upload.");
      return FirebaseStorage.instance.ref().child('path/to/store/${DateTime.now().millisecondsSinceEpoch}.jpg');
    } else {
      print("Image data is empty.");
      throw Exception("No image data provided.");
    }
  }

  Future<void> addTodo(String task, [Uint8List? imageData]) async {
    final user = authService.user;
    if (user != null) {
      String imageUrl = '';
      Reference? storageRef;
      if (imageData != null && imageData.isNotEmpty) {
        storageRef = await prepareImageUpload(imageData); // Prepare the upload
        await storageRef.putData(imageData); // Perform the actual upload
        imageUrl = await storageRef.getDownloadURL(); // Get the URL after upload
      }
      ToDo todo = ToDo(
        id: '',
        task: task,
        userId: user.uid,
        userName: user.displayName ?? 'Unknown',
        imageUrl: imageUrl,
      );

      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('pb_todo')
          .add(todo.toMap());
    }
  }

  Future<void> removeTodoAt(int index) async {
    String todoId = todos[index].id;
    await FirebaseFirestore.instance
        .collection('pb_todo')
        .doc(todoId)
        .delete();
  }

  Future<void> toggleDone(int index) async {
    ToDo todo = todos[index];
    todo.isDone = !todo.isDone;
    await FirebaseFirestore.instance
        .collection('pb_todo')
        .doc(todo.id)
        .update(todo.toMap());
  }

  Future<void> editTodo(int index, String newTask) async {
    ToDo todo = todos[index];
    todo.task = newTask;
    await FirebaseFirestore.instance
        .collection('pb_todo')
        .doc(todo.id)
        .update(todo.toMap());
  }
}
