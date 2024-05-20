import 'package:captainapp_crew_dashboard/controller/auth/reset_password_controller.dart';
import 'package:captainapp_crew_dashboard/helpers/extensions/string.dart';
import 'package:captainapp_crew_dashboard/helpers/theme/app_theme.dart';
import 'package:captainapp_crew_dashboard/helpers/utils/ui_mixins.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_button.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_flex.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_flex_item.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_responsiv.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_screen_media_type.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_spacing.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_text.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_text_style.dart';
import 'package:captainapp_crew_dashboard/images.dart';
import 'package:captainapp_crew_dashboard/views/layouts/auth_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword>
    with SingleTickerProviderStateMixin, UIMixin {
  late ResetPasswordController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ResetPasswordController());
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      child: GetBuilder(
        init: controller,
        builder: (controller) {
          return Padding(
            padding: MySpacing.all(16),
            child: MyFlex(
              contentPadding: false,
              children: [
                MyFlexItem(
                  sizes: "lg-6",
                  child: MyResponsive(
                    builder: (_, __, type) {
                      return type == MyScreenMediaType.xxl
                          ? Image.asset(
                              Images.login[4],
                              fit: BoxFit.fitHeight,
                              height: 500,
                            )
                          : type == MyScreenMediaType.xl
                              ? Image.asset(
                                  Images.login[4],
                                  fit: BoxFit.fitHeight,
                                  height: 500,
                                )
                              : type == MyScreenMediaType.lg
                                  ? Image.asset(
                                      Images.login[4],
                                      fit: BoxFit.fitHeight,
                                      height: 500,
                                    )
                                  : const SizedBox();
                    },
                  ),
                ),
                MyFlexItem(
                  sizes: "lg-6",
                  child: Padding(
                    padding: MySpacing.y(16),
                    child: Form(
                      key: controller.basicValidator.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: MyText.titleLarge(
                              "reset_password".tr().capitalizeWords,
                              fontWeight: 700,
                            ),
                          ),
                          MySpacing.height(10),
                          Center(
                            child: MyText.bodySmall(
                              "your_password_will_be_reset".tr(),
                              muted: true,
                            ),
                          ),
                          MySpacing.height(45),
                          MyText.labelMedium("password".tr()),
                          MySpacing.height(4),
                          TextFormField(
                            validator: controller.basicValidator
                                .getValidation('password'),
                            controller: controller.basicValidator
                                .getController('password'),
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: !controller.showPassword,
                            decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle: MyTextStyle.bodySmall(xMuted: true),
                              border: outlineInputBorder,
                              prefixIcon: const Icon(
                                LucideIcons.lock,
                                size: 20,
                              ),
                              suffixIcon: InkWell(
                                onTap: controller.onChangeShowPassword,
                                child: Icon(
                                  controller.showPassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 20,
                                ),
                              ),
                              contentPadding: MySpacing.all(16),
                              isCollapsed: true,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                            ),
                          ),
                          MySpacing.height(15),
                          MyText.labelMedium(
                            "confirm_password".tr().capitalizeWords,
                          ),
                          MySpacing.height(4),
                          TextFormField(
                            validator: controller.basicValidator
                                .getValidation('confirm_password'),
                            controller: controller.basicValidator
                                .getController('confirm_password'),
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: controller.confirmPassword,
                            decoration: InputDecoration(
                              labelText: "Confirm Password",
                              labelStyle: MyTextStyle.bodySmall(xMuted: true),
                              border: outlineInputBorder,
                              prefixIcon: const Icon(
                                LucideIcons.lock,
                                size: 20,
                              ),
                              suffixIcon: InkWell(
                                onTap: controller.onResetPassword,
                                child: Icon(
                                  controller.confirmPassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  size: 20,
                                ),
                              ),
                              contentPadding: MySpacing.all(16),
                              isCollapsed: true,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                            ),
                          ),
                          MySpacing.height(25),
                          Center(
                            child: MyButton.rounded(
                              onPressed: controller.onResetPassword,
                              elevation: 0,
                              padding: MySpacing.xy(20, 16),
                              backgroundColor: contentTheme.primary,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  controller.loading
                                      ? SizedBox(
                                          height: 14,
                                          width: 14,
                                          child: CircularProgressIndicator(
                                            color: theme.colorScheme.onPrimary,
                                            strokeWidth: 1.2,
                                          ),
                                        )
                                      : Container(),
                                  if (controller.loading) MySpacing.width(16),
                                  MyText.bodySmall(
                                    'confirm'.tr(),
                                    color: contentTheme.onPrimary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
