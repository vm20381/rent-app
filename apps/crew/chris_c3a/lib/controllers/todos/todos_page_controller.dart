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
    // orders by isDone so that the unfinished todos are shown first
    _todos = _todosCollection.orderBy('isDone').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Todo.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Stream<List<Todo>> getTodos() {
    return _todos;
  }

  Future<void> addTodo(Todo todo) async {
    DocumentReference docRef = await _todosCollection.add(todo.toMap());
    // Update the Todo object with the ID from Firestore and add it back to Firestore
    todo = todo.copyWith(id: docRef.id);
    // Update id field in firestore
    await _todosCollection.doc(docRef.id).set(todo.toMap());
  }

  Future<void> updateTodo(Todo todo) {
    return _todosCollection.doc(todo.id).update(todo.toMap());
  }

  Future<void> deleteTodo(String id) {
    return _todosCollection.doc(id).delete();
  }
}
