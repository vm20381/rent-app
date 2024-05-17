import 'package:captainapp_crew_dashboard/controller/my_controller.dart';
import 'package:captainapp_crew_dashboard/helpers/services/auth_services.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_form_validator.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Register2Controller extends MyController {
  MyFormValidator basicValidator = MyFormValidator();

  final authService = Get.find<AuthService>();

  bool showPassword = false, loading = false;

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
    basicValidator.addField(
      'first_name',
      required: true,
      label: 'First Name',
      controller: TextEditingController(),
    );
    basicValidator.addField(
      'last_name',
      required: true,
      label: 'Last Name',
      controller: TextEditingController(),
    );
    basicValidator.addField(
      'password',
      required: true,
      validators: [MyLengthValidator(min: 6, max: 10)],
      controller: TextEditingController(),
    );
  }

  Future<void> onRegister() async {
    if (basicValidator.validateForm()) {
      loading = true;
      update();

      String email = basicValidator.getController('email')?.text ?? "";
      String firstName = basicValidator.getController('first_name')?.text ?? "";
      String lastName = basicValidator.getController('last_name')?.text ?? "";
      String password = basicValidator.getController('password')?.text ?? "";

      var errors =
          await authService.registerUser(email, password, firstName, lastName);
      if (errors != null) {
        basicValidator.addErrors(errors);
        basicValidator.validateForm();
        basicValidator.clearErrors();
      } else {
        Get.toNamed(
          '/starter',
        ); // Navigate to the starter page on successful registration
      }

      loading = false;
      update();
    }
  }

  void onChangeShowPassword() {
    showPassword = !showPassword;
    update();
  }

  void gotoLogin() {
    Get.toNamed('/auth/login1');
  }
}
