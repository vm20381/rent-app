import 'package:edsu03/helpers/services/auth_services.dart';
import 'package:get/get.dart';

class NewPageController extends GetxController {

  final authService = Get.find<AuthService>();

  RxString userRole = ''.obs;

    void navigateToHomePage() {
    Get.toNamed('/');
  }

  void navigateToProfile() {
    Get.toNamed('/my-profile');
  }

  @override
  void onInit() {
    authService.userRoles.listen((claims) {
      if (claims == null) {
        userRole.value = '';
        return;
      }
      // by virtue of being an observable, this will update the view automagically, plus be more efficient than calling update() since it will only update the part of the view that needs updating rather than calling the build method of the entire view.
      userRole.value = claims['role'];
    });
  }
}


