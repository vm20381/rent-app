import 'package:chris_c3a/controllers/my_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../models/todo_model.dart';

class TodosPageController extends MyController {
  //  reference to the collection of todos in Firestore
  final CollectionReference _todosCollection =
      FirebaseFirestore.instance.collection('todos');

  // list of todos
  late Stream<List<Todo>> _todos;

  @override
  void onInit() {
    super.onInit();

    // get the todos from Firestore
    _todos = _todosCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Todo.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Stream<List<Todo>> getTodos() {
    return _todos;
  }

  Future<void> addTodo(Todo todo) {
    return _todosCollection.add(todo.toMap());
  }

  Future<void> updateTodo(Todo todo) {
    return _todosCollection.doc(todo.id).update(todo.toMap());
  }

  Future<void> deleteTodo(String id) {
    return _todosCollection.doc(id).delete();
  }
}
