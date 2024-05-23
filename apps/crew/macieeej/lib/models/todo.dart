// A model for a todo list item
import 'package:cloud_firestore/cloud_firestore.dart';

class ToDo {
  String id;
  String task;
  bool isDone;
  String userId;
  String userName;

  ToDo({
    required this.id,
    required this.task,
    this.isDone = false,
    required this.userId,
    required this.userName,
  });

  factory ToDo.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ToDo(
      id: doc.id,
      task: data['task'],
      isDone: data['isDone'],
      userId: data['userId'],
      userName: data['userName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'task': task,
      'isDone': isDone,
      'userId': userId,
      'userName': userName,
    };
  }
}