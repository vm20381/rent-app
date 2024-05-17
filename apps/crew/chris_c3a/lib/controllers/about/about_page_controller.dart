import 'package:get/get.dart';
import '../../helpers/services/auth_services.dart';

class AboutPageController extends GetxController {
  // Add your controller logic here

  // navigate to the home page function
  void navigateToHome() {
    Get.toNamed('/');
  }

  final authService = Get.find<AuthService>();

  // Observable string to hold the user role
  RxString userRole = ''.obs;

  @override
  void onInit() {
    super.onInit();
    authService.userRoles.listen((roles) {
      userRole.value = roles['role'];
    });
  }
}
