import 'package:captainapp_crew_dashboard/controller/my_controller.dart';
import 'package:captainapp_crew_dashboard/helpers/services/firebase_functions_service.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_form_validator.dart';
import 'package:captainapp_crew_dashboard/models/firebase_auth_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';

class CreateUserController extends MyController {
  final MyFormValidator validator = MyFormValidator();
  bool showPassword = false;
  bool loading = false;

  // Using TextEditingControllers to manage form inputs
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController displayNameController = TextEditingController();

  // Toggles the password visibility
  void onChangeShowPassword() {
    showPassword = !showPassword;
    update(); // Update the UI
  }

  // Validation logic for email and password
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value)) {
      return 'Invalid email format';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateDisplayName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Display name is required';
    }
    return null;
  }

  Future<void> createUser() async {
    if (!loading &&
        validateEmail(emailController.text) == null &&
        validatePassword(passwordController.text) == null) {
      loading = true;
      update(); // Notify listeners about state change

      try {
        // Call the Firebase function to create a user
        final functionsService = Get.find<FirebaseFunctionService>();
        await functionsService.callCreateFunction(
          'createUser',
          {
            'email': emailController.text,
            'password': passwordController.text,
            'displayName': displayNameController.text,
          },
        );
        Get.toNamed('/admin/users'); // Navigate to user list
        Get.snackbar(
          'Success',
          'User created successfully',
          snackPosition: SnackPosition.TOP,
        );
        // Optional: Clear form or navigate away upon success
      } catch (e) {
        // Handle errors
        print('Error creating user: $e');
      } finally {
        loading = false;
        update(); // Update state
      }
    }
  }
}
