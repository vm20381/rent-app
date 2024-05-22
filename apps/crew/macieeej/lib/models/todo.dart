// A model for a todo list item
class ToDo {
  String task;
  bool isDone;
  String userId;
  String userName;

  ToDo({
    required this.task,
    this.isDone = false,
    required this.userId,
    required this.userName,
  });
}