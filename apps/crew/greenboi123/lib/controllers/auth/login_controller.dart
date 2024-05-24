import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../my_controller.dart';
import '/helpers/services/auth_services.dart';
import '/helpers/widgets/my_form_validator.dart';
import '/helpers/widgets/my_validators.dart';

class LoginController extends MyController {
  MyFormValidator basicValidator = MyFormValidator();

  bool showPassword = false, loading = false, isChecked = false;

  final String _dummyEmail = "felix@captainapp.co.uk";
  final String _dummyPassword = "iamthecaptainnow";

  final authService = Get.find<AuthService>();

  @override
  void onInit() {
    super.onInit();
    basicValidator.addField(
      'email',
      required: true,
      label: "Email",
      validators: [MyEmailValidator()],
      controller: TextEditingController(text: _dummyEmail),
    );

    basicValidator.addField(
      'password',
      required: true,
      label: "Password",
      validators: [MyLengthValidator(min: 6, max: 50)],
      controller: TextEditingController(text: _dummyPassword),
    );
  }

  void onChangeShowPassword() {
    showPassword = !showPassword;
    update();
  }

  void onChangeCheckBox(bool? value) {
    isChecked = value ?? isChecked;
    update();
  }

  Future<void> onLogin() async {
    if (basicValidator.validateForm()) {
      loading = true;
      update();
      String email = basicValidator.getController('email')?.text ?? "";
      String password = basicValidator.getController('password')?.text ?? "";
      var errors = await authService.loginUser(email, password);
      if (errors != null) {
        basicValidator.addErrors(errors);
        basicValidator.validateForm();
        basicValidator.clearErrors();
      } else {
        String nextUrl =
            Uri.parse(ModalRoute.of(Get.context!)?.settings.name ?? "")
                    .queryParameters['next'] ??
                "/";
        Get.toNamed(
          nextUrl,
        );
      }
      loading = false;
      update();
    }
  }

  void goToForgotPassword() {
    Get.toNamed('/auth/forgot_password');
  }

  void gotoRegister() {
    Get.offAndToNamed('/auth/register');
  }
}
