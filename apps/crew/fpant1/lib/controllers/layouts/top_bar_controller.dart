import 'package:get/get.dart';

import '/helpers/services/auth_services.dart';

class TopBarController extends GetxController {
  final AuthService authService = Get.find<AuthService>();
  final RxString displayName = "".obs; // Reactive display name
  final RxString photoURL = "".obs; // Reactive photo URL

  @override
  void onInit() {
    super.onInit();
    displayName.value = authService.user?.displayName ??
        "Guest"; // Initialize with current user's display name or default
    photoURL.value = authService.user?.photoURL ?? "";
    // Listen to changes in user authentication state
    authService.firebaseUser.listen((user) {
      displayName.value = user?.displayName ?? "Guest";
      photoURL.value = user?.photoURL ?? "";
    });
  }

  void logout() async {
    await authService.signOut();
    Get.offAllNamed(
      '/auth/login',
    ); // Navigate to login screen and remove all previous routes
  }

  void toggleTheme() {
    // Implement theme toggle logic
  }

  void changeLanguage(String languageCode) {
    // Implement language change logic
  }
}
