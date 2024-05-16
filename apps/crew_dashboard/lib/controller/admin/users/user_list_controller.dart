import 'package:captainapp_crew_dashboard/controller/my_controller.dart';
import 'package:captainapp_crew_dashboard/helpers/services/auth_services.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_form_validator.dart';
import 'package:captainapp_crew_dashboard/models/firebase_auth_user.dart';
import 'package:get/get.dart';

class UserListController extends MyController {
  List<FirebaseAuthUser> users = [];
  late final AuthService authService;

  MyFormValidator basicValidator = MyFormValidator();
  bool loading = false;

  @override
  void onInit() {
    super.onInit();
    authService = Get.find<AuthService>();
    _loadUsersFromFirebaseAuth();
  }

  Future<void> _loadUsersFromFirebaseAuth() async {
    loading = true;
    update();
    users = await authService.loadAllUsers();
    loading = false;
    update();
  }

  void setUserRole(String uid, String role) async {
    loading = true;
    if (!await authService.setUserRole(uid, role)) {
      Get.snackbar(
        'Error',
        'Failed to set role to $role',
        snackPosition: SnackPosition.TOP,
      );
      loading = false;
      return;
    }
    update();
    Get.snackbar(
      'Success',
      'Role set to $role',
      snackPosition: SnackPosition.TOP,
    );
    // refresh users
    await _loadUsersFromFirebaseAuth();
    update(); // Trigger UI update
    loading = false;
  }
}
