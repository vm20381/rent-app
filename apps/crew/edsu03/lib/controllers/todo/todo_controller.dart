import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edsu03/helpers/services/auth_services.dart';
import 'package:edsu03/helpers/services/firestore_subscription_services.dart';
import 'package:edsu03/models/todo.dart';
import 'package:get/get.dart';

class ToDoPageController extends GetxController {

  final authService = Get.find<AuthService>();

  final FirestoreSubscriptionService _firestoreSubService = Get.find<FirestoreSubscriptionService>();
  var todos = <TodoItem>[].obs;
  //RxString userRole = ''.obs;

  void _subscribeToTodoItems() {
    _firestoreSubService.collectionStream<TodoItem>(
      'todos',
      (data, documentId) => TodoItem.fromFirestore(data, documentId),
    ).listen((todoItems) {
      todos.value = todoItems;
    });
  }

  @override
  void onInit() {
    super.onInit();
    _subscribeToTodoItems();
  }
}


