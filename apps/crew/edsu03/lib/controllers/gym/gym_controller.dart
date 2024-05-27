import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edsu03/helpers/services/auth_services.dart';
import 'package:edsu03/helpers/services/firestore_subscription_services.dart';
import 'package:edsu03/models/gym.dart';
import 'package:edsu03/models/todo.dart';
import 'package:get/get.dart';

class GymController extends GetxController {

  final authService = Get.find<AuthService>();


  final FirestoreSubscriptionService _firestoreSubService = Get.find<FirestoreSubscriptionService>();
  var gymRoutines = <GymRoutine>[].obs;
  //RxString userRole = ''.obs;
  @override
  void onInit() {
    super.onInit();
    _subscribeToGymRoutines();
  }

  void _subscribeToGymRoutines() {
    _firestoreSubService.collectionStream<GymRoutine>(
      'gymRoutines',
      (data, documentId) => GymRoutine.fromFirestore(data, documentId),
    ).listen((gymRoutineItems) {
      gymRoutines.value = gymRoutineItems;
    });
  }

  Future<void> addRoutine(String owner, String description) async {
    final user = authService.user;
    if (user != null) {
      GymRoutine gymRoutine = GymRoutine(
        owner: owner,
        days: List.empty(),
      );
      await FirebaseFirestore.instance.collection('gymRoutines').add(gymRoutine.toFirestore());
    }
  }

  Future<void> addDay(GymDay day, int index) async {
    final user = authService.user;
    if (user != null) {
      gymRoutines[index].days.add(day);
    }

  }
}


