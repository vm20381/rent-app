import '../my_controller.dart';
import '/helpers/services/auth_services.dart';
import '/helpers/widgets/my_form_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditUserProfileController extends MyController {
  final AuthService authService = Get.find<AuthService>();
  final MyFormValidator validation = MyFormValidator();

  bool loading = false;

  bool showPassword = false;
  XFile image = XFile('assets/images/default_user.png');

  String get userProfilePictureUrl =>
      authService.user?.photoURL ??
      'https://as1.ftcdn.net/v2/jpg/05/87/76/66/1000_F_587766653_PkBNyGx7mQh9l1XXPtCAq1lBgOsLl6xH.jpg'; // placeholder empty profile image

  @override
  void onInit() {
    super.onInit();
    updateUserFormFields();
  }

  void togglePasswordVisibility() {
    showPassword = !showPassword;
    update();
  }

  void updateUserFormFields() {
    User? user = authService.user;
    validation.addField(
      'First Name',
      controller: TextEditingController(
        text: user?.displayName?.split(' ').first ?? '',
      ),
    );
    validation.addField(
      'Last Name',
      controller:
          TextEditingController(text: user?.displayName?.split(' ').last ?? ''),
    );
  }

  void updateProfile() async {
    String firstName = validation.getController('First Name')?.text ?? '';
    String lastName = validation.getController('Last Name')?.text ?? '';
    try {
      await authService.updateDisplayName(
        firstName: firstName,
        lastName: lastName,
      );
      Get.snackbar('Success', 'Profile updated successfully');
      update();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile');
    }
  }

  Future<void> handleImageSelection() async {
    final ImagePicker picker = ImagePicker();
    final XFile? newImage = await picker.pickImage(source: ImageSource.gallery);
    loading = true;
    if (newImage == null) {
      Get.snackbar('Error', 'Failed to select image, please try again.');
      return;
    }
    // call cloud function to upload to firebase storage and receive the download URL
    try {
      final downloadURL =
          await authService.uploadProfileImageToFirebaseStorage(newImage);
      await updateProfilePicture(downloadURL);
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload image, please try again.');
    }
  }

  Future<void> updateProfilePicture(String downloadURL) async {
    loading = true;
    update();
    await authService.updateUserPhotoURL(downloadURL);
    Get.snackbar('Success', 'Profile picture updated successfully');
    loading = false;
    update();
  }
}
