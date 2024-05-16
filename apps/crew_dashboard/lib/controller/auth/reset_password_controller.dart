import 'package:captainapp_crew_dashboard/controller/my_controller.dart';
import 'package:captainapp_crew_dashboard/helpers/services/auth_services.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_form_validator.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordController extends MyController {
  MyFormValidator basicValidator = MyFormValidator();

  final authService = Get.find<AuthService>();

  bool showPassword = false, loading = false;
  bool confirmPassword = false;

  @override
  void onInit() {
    super.onInit();
    basicValidator.addField(
      'password',
      required: true,
      validators: [MyLengthValidator(min: 6, max: 10)],
      controller: TextEditingController(),
    );
    basicValidator.addField(
      'confirm_password',
      required: true,
      label: "Confirm password",
      validators: [MyLengthValidator(min: 6, max: 10)],
      controller: TextEditingController(),
    );
  }

  Future<void> onResetPassword() async {
    if (basicValidator.validateForm()) {
      String password = basicValidator.getController('password')?.text ?? "";
      String confirmPassword =
          basicValidator.getController('confirm_password')?.text ?? "";

      if (password != confirmPassword) {
        basicValidator.addError('confirm_password', 'Passwords do not match');
        basicValidator.validateForm();
        update();
        return;
      }

      loading = true;
      update();

      var errors = await authService.updatePassword(password);
      if (errors != null) {
        basicValidator.addErrors(errors);
        basicValidator.validateForm();
        basicValidator.clearErrors();
      } else {
        Get.toNamed(
          '/dashboard',
        ); // Navigate to dashboard on successful password reset
      }

      loading = false;
      update();
    }
  }

  void onChangeShowPassword() {
    showPassword = !showPassword;
    update();
  }
}
