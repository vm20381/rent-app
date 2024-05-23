import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:macieeej/helpers/services/auth_services.dart';
import '../../models/todo.dart';


class ToDoListController extends GetxController {
  var todos = <ToDo>[].obs;
  final AuthService authService = Get.find<AuthService>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchTodos();
  }

  Future<void> fetchTodos() async {
    QuerySnapshot snapshot = await _firestore.collection('todo_items').get();
    todos.value = snapshot.docs.map((doc) => ToDo.fromDocument(doc)).toList();
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
      DocumentReference docRef = await _firestore.collection('todo_items').add(todo.toMap());
      todo.id = docRef.id;
      todos.add(todo);
    }
  }

  Future<void> removeTodoAt(int index) async {
    String todoId = todos[index].id;
    await _firestore.collection('todo_items').doc(todoId).delete();
    todos.removeAt(index);
  }

  Future<void> toggleDone(int index) async {
    ToDo todo = todos[index];
    todo.isDone = !todo.isDone;
    await _firestore.collection('todo_items').doc(todo.id).update(todo.toMap());
    todos[index] = todo;
  }

  Future<void> editTodo(int index, String newTask) async {
    ToDo todo = todos[index];
    todo.task = newTask;
    await _firestore.collection('todo_items').doc(todo.id).update(todo.toMap());
    todos[index] = todo;
  }
}