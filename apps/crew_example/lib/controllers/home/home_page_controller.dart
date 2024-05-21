import 'package:crew_example/helpers/services/firestore_subscription_services.dart';
import 'package:example_package/example_package.dart';
import 'package:get/get.dart';

import '../../helpers/services/auth_services.dart';

class HomePageController extends GetxController {
  late String nameOfUser;
  late String serviceMessage;
  
  final FirestoreService _firestoreService = Get.find<FirestoreService>();

  @override
  void onInit() {
    super.onInit();
    final authService = Get.find<AuthService>();
    nameOfUser = authService.user!.displayName!.split(' ')[0];

    // see main.dart for how to register services so they can be found at runtime.
    serviceMessage = Get.find<ExamplePackageService>().getHello();

    // Call printFirstTodo when controller is initialized
    printFirstTodo();
  }

  Stream<List<TodoItem>> get myCollectionStream {
    return _firestoreService.collectionStream<TodoItem>(
      'todos',
      (data, documentId) => TodoItem.fromFirestore(data, documentId),
    );
  }

  // print out the first todo item in full
  void printFirstTodo() {
    myCollectionStream.first.then((todoItems) {
      if (todoItems.isNotEmpty) {
        var firstTodo = todoItems.first;
        print('First todo item: ${firstTodo.title}');
        print('Description: ${firstTodo.description}');
        print('ID: ${firstTodo.id}');
      } else {
        print('No todo items found.');
      }
    }).catchError((error) {
      print('Error fetching todo items: $error');
    });
  }
  // add other methods here
}
