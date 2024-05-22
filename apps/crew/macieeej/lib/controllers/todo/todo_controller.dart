import 'package:get/get.dart';
import 'package:macieeej/helpers/services/auth_services.dart';
import '../../models/todo.dart';


class ToDoListController extends GetxController {
  var todos = <ToDo>[].obs;
  final AuthService authService = Get.find<AuthService>();

  void addTodo(String task) {
    final user = authService.user;
    if (user != null) {
      todos.add(ToDo(
        task: task,
        userId: user.uid,
        userName: user.displayName ?? 'Unknown',
      ));
    }
  }

  void removeTodoAt(int index) {
    todos.removeAt(index);
  }

  void toggleDone(int index) {
    var todo = todos[index];
    todo.isDone = !todo.isDone;
    todos[index] = todo; // This line is important to update the observable list.
  }
}