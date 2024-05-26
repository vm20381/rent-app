import 'package:cloud_firestore/cloud_firestore.dart';

class ToDo {
  String id;
  String task;
  bool isDone;
  String userId;
  String userName;
  String? imageUrl; // Optional field for image URL

  ToDo({
    required this.id,
    required this.task,
    this.isDone = false,
    required this.userId,
    required this.userName,
    this.imageUrl,
  });

  factory ToDo.fromFirestore(Map<String, dynamic> data, String documentId) {
    return ToDo(
      id: documentId,
      task: data['task'] ?? '',
      isDone: data['isDone'] ?? false,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? 'Unknown',
      imageUrl: data['imageUrl'], // Retrieve image URL from Firestore document
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'task': task,
      'isDone': isDone,
      'userId': userId,
      'userName': userName,
      'imageUrl': imageUrl, // Include image URL in Firestore document
    };
  }
}

