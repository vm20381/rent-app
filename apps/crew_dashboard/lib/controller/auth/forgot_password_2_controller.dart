import 'package:captainapp_crew_dashboard/controller/my_controller.dart';
import 'package:captainapp_crew_dashboard/helpers/services/auth_services.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_form_validator.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPassword2Controller extends MyController {
  MyFormValidator basicValidator = MyFormValidator();
  bool loading = false;

  @override
  void onInit() {
    super.onInit();
    basicValidator.addField(
      'email',
      required: true,
      label: "Email",
      validators: [MyEmailValidator()],
      controller: TextEditingController(),
    );
  }

  Future<void> onRequestPasswordReset() async {
    if (basicValidator.validateForm()) {
      loading = true;
      update();

      String email = basicValidator.getController('email')?.text ?? "";
      var errors = await AuthService.sendPasswordResetEmail(email);

      if (errors != null) {
        // Add and show errors in the UI
        basicValidator.addErrors(errors);
        basicValidator.validateForm(clear: false);
      } else {
        // Navigate or show confirmation on successful email sending
        Get.snackbar(
          'Success',
          'Password reset email sent!',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      loading = false;
      update();
    }
  }

  void gotoLogIn() {
    Get.toNamed('/auth/login1');
  }
}
