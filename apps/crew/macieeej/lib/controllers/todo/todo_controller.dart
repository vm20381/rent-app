import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:macieeej/helpers/services/auth_services.dart';
import 'package:macieeej/helpers/services/firebase_subscription_services.dart';
import '../../models/todo.dart';


class ToDoListController extends GetxController {
  var todos = <ToDo>[].obs;
  final AuthService authService = Get.find<AuthService>();
  final FirestoreSubscriptionService _firestoreSubService = Get.find<FirestoreSubscriptionService>();

  @override
  void onInit() {
    super.onInit();
    _subscribeToTodoItems();
  }

  void _subscribeToTodoItems() {
    _firestoreSubService.collectionStream<ToDo>(
      'todo_items',
      (data, documentId) => ToDo.fromFirestore(data, documentId),
    ).listen((todoItems) {
      todos.value = todoItems;
    });
  }

  Future<void> addTodo(String task) async {
    final user = authService.user;
    if (user != null) {
      ToDo todo = ToDo(
        id: '',
        task: task,
        userId: user.uid,
        userName: user.displayName ?? 'Unknown',
      );
      await FirebaseFirestore.instance.collection('todo_items').add(todo.toMap());
    }
  }

  Future<void> removeTodoAt(int index) async {
    String todoId = todos[index].id;
    await FirebaseFirestore.instance.collection('todo_items').doc(todoId).delete();
  }

  Future<void> toggleDone(int index) async {
    ToDo todo = todos[index];
    todo.isDone = !todo.isDone;
    await FirebaseFirestore.instance.collection('todo_items').doc(todo.id).update(todo.toMap());
  }

  Future<void> editTodo(int index, String newTask) async {
    ToDo todo = todos[index];
    todo.task = newTask;
    await FirebaseFirestore.instance.collection('todo_items').doc(todo.id).update(todo.toMap());
  }
}