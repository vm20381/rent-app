import 'package:example_package/example_package.dart';
import 'package:get/get.dart';

import '../../helpers/services/auth_services.dart';

class HomePageController extends GetxController {
  late String nameOfUser;
  late String serviceMessage;
  @override
  void onInit() {
    super.onInit();
    final authService = Get.find<AuthService>();
    nameOfUser = authService.user!.displayName!.split(' ')[0];

    // see main.dart for how to register services so they can be found at runtime.
    serviceMessage = Get.find<ExamplePackageService>().getHello();
  }

  // add other methods here
}
