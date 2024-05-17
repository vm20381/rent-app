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
    authService.userRoles.listen((roles) {
      if (roles == null) {
        userRole.value = '';
        return;
      }
      // by virtue of being an observable, this will update the view automatically,
      // plus be more efficient than calling update() since it will only update the part of the view that needs updating rather than calling the build method of the entire view.
      userRole.value = roles['role'];
    });
  }
}
