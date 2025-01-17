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

// Example model class
