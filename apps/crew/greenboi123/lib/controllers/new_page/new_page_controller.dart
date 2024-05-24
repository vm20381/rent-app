import 'package:get/get.dart';
import 'package:greenboi123/helpers/services/auth_services.dart';

class NewPageController extends GetxController {
  void navigateToHomePage() {
    Get.toNamed('/home');
  }
  final authService = Get.find<AuthService>();

  RxString userRole = ''.obs;

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