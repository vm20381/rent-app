import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

abstract class FirestoreSubscriptionService {
  Stream<List<T>> collectionStream<T>(
    String collectionPath,
    T Function(Map<String, dynamic> data, String documentId) fromFirestore,
  );
}

class FirestoreServiceImpl extends GetxService
    implements FirestoreSubscriptionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<T>> collectionStream<T>(
    String collectionPath,
    T Function(Map<String, dynamic> data, String documentId) fromFirestore,
  ) {
    return _firestore.collection(collectionPath).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => fromFirestore(doc.data(), doc.id))
          .toList();
    });
  }
}


// Example model class
class TodoItem {
  final String id;
  final String title;
  final String description;
  bool isDone;

  TodoItem({
    required this.id,
    required this.title,
    required this.description,
    required this.isDone,
  });

  factory TodoItem.fromFirestore(Map<String, dynamic> data, String documentId) {
    return TodoItem(
      id: documentId,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      isDone: data['isDone'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'isDone': isDone,
    };
  }
}
