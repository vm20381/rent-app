import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:captainapp_crew_dashboard/controller/my_controller.dart';
import 'package:captainapp_crew_dashboard/helpers/services/auth_services.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_form_validator.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_validators.dart';

class Login2Controller extends MyController {
  MyFormValidator basicValidator = MyFormValidator();

  bool showPassword = false, loading = false, isChecked = false;

  final String _dummyEmail = "CaptainApp@getappui.com";
  final String _dummyPassword = "1234567";
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
                "/dashboard";
        Get.toNamed(
          nextUrl,
        );
      }
      loading = false;
      update();
    }
  }

  void goToForgotPassword() {
    Get.toNamed('/auth/forgot_password1');
  }

  void gotoRegister() {
    Get.offAndToNamed('/auth/register1');
  }
}
