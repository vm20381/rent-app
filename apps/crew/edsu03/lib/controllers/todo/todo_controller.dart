import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edsu03/helpers/services/auth_services.dart';
import 'package:edsu03/helpers/services/firestore_subscription_services.dart';
import 'package:edsu03/models/todo.dart';
import 'package:get/get.dart';

class ToDoPageController extends GetxController {

  final authService = Get.find<AuthService>();

  final FirestoreSubscriptionService _firestoreSubService = Get.find<FirestoreSubscriptionService>();
  var todos = <TodoItem>[].obs;
  //RxString userRole = ''.obs;
  @override
  void onInit() {
    super.onInit();
    _subscribeToTodoItems();
  }

  void _subscribeToTodoItems() {
    _firestoreSubService.collectionStream<TodoItem>(
      'todos',
      (data, documentId) => TodoItem.fromFirestore(data, documentId),
    ).listen((todoItems) {
      todos.value = todoItems;
    });
  }

    Future<void> addTodo(String title, String description) async {
    final user = authService.user;
    if (user != null) {
      TodoItem todo = TodoItem(
        id: '',
        title: title,
        description: description,
        isDone: false,
      );
      await FirebaseFirestore.instance.collection('todos').add(todo.toFirestore());
    }
  }

  Future<void> removeTodo(int index) async {
    String todoId = todos[index].id;
    await FirebaseFirestore.instance.collection('todos').doc(todoId).delete();
  }

    Future<void> toggleDone(int index) async {
    TodoItem todo = todos[index];
    todo.isDone = !todo.isDone;
    await FirebaseFirestore.instance.collection('todos').doc(todo.id).update(todo.toFirestore());
  }


  void editTodo() {

  }

}


