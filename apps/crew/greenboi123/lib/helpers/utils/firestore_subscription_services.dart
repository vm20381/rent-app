import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

abstract class FirestoreSubscriptionService {
  Stream<List<T>> collectionStream<T>(
    String collectionPath,
    T Function(Map<String, dynamic> data, String documentId) fromFirestore,
  );

  Future<void> addDocument(String collectionPath, Map<String, dynamic> data);

  Future<void> updateDocument(String collectionPath, String documentId, Map<String, dynamic> data);

  Future<void> deleteDocument(String collectionPath, String documentId);
}

class FirestoreServiceImpl extends GetxService implements FirestoreSubscriptionService {
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

  @override
  Future<void> addDocument(String collectionPath, Map<String, dynamic> data) async {
    await _firestore.collection(collectionPath).add(data);
  }

  @override
  Future<void> updateDocument(String collectionPath, String documentId, Map<String, dynamic> data) async {
    await _firestore.collection(collectionPath).doc(documentId).update(data);
  }

  @override
  Future<void> deleteDocument(String collectionPath, String documentId) async {
    await _firestore.collection(collectionPath).doc(documentId).delete();
  }
}


// Ensure to include the following in main.dart
// Get.put<FirestoreService>(FirestoreServiceImpl());

// Example of how to use FirestoreService in a controller
// class MyController extends GetxController {
//   final FirestoreService _firestoreService = Get.find<FirestoreService>();

//   Stream<List<TodoItem>> get myCollectionStream {
//     return _firestoreService.collectionStream<TodoItem>(
//       'myCollection',
//       (data, documentId) => TodoItem.fromFirestore(data, documentId),
//     );
//   }
// }

// // Example model class
// class TodoItem {
//   final String id;
//   final String title;
//   final String description;
//   bool isDone;

//   TodoItem({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.isDone,
//   });

//   factory TodoItem.fromFirestore(Map<String, dynamic> data, String documentId) {
//     return TodoItem(
//       id: documentId,
//       title: data['title'] ?? '',
//       description: data['description'] ?? '',
//       isDone: data['isDone'] ?? false,
//     );
//   }

//   Map<String, dynamic> toFirestore() {
//     return {
//       'title': title,
//       'description': description,
//       'isDone': isDone,
//     };
//   }
// }
