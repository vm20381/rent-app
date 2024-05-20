import 'package:get/get.dart';
import '../../models/todo.dart';

class ToDoListController extends GetxController {
  var todos = <String>[].obs;

  void addTodo(String todo) {
    todos.add(todo);
  }

  void removeTodoAt(int index) {
    todos.removeAt(index);
  }
}