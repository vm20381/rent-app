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
    super.onInit();
    authService.userRoles.listen((claims) {
      userRole.value = claims['role'];
    });
  }
}