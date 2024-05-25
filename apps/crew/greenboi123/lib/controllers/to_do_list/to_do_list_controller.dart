import 'package:get/get.dart';
import 'package:greenboi123/helpers/services/auth_services.dart';
import 'package:greenboi123/helpers/utils/firestore_subscription_services.dart';
import 'package:greenboi123/models/to_do_list_model.dart';

class ToDoController extends GetxController {
  final FirestoreSubscriptionService _firestoreService = Get.find<FirestoreSubscriptionService>();

  Stream<List<TodoItem>> get myCollectionStream {
    return _firestoreService.collectionStream<TodoItem>(
      'fg_to_do_list',
      (data, documentId) => TodoItem.fromFirestore(data, documentId),
    );
  }

  void addTodoItem(TodoItem item) {
    _firestoreService.addDocument('fg_to_do_list', item.toFirestore());
  }

  void updateTodoItem(TodoItem item) {
    _firestoreService.updateDocument('fg_to_do_list', item.id, item.toFirestore());
  }

  void deleteTodoItem(String id) {
    _firestoreService.deleteDocument('fg_to_do_list', id);
  }
}
