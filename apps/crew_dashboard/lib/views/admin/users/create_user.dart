import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:captainapp_crew_dashboard/controller/admin/users/create_user_controller.dart';
import 'package:captainapp_crew_dashboard/helpers/theme/app_style.dart';
import 'package:captainapp_crew_dashboard/helpers/utils/my_shadow.dart';
import 'package:captainapp_crew_dashboard/helpers/utils/my_string_utils.dart';
import 'package:captainapp_crew_dashboard/helpers/utils/ui_mixins.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_breadcrumb.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_breadcrumb_item.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_button.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_card.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_container.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_flex.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_flex_item.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_spacing.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_text.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_text_style.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/responsive.dart';
import 'package:captainapp_crew_dashboard/images.dart';
import 'package:captainapp_crew_dashboard/views/layouts/layout.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({super.key});

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser>
    with SingleTickerProviderStateMixin, UIMixin {
  late CreateUserController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(CreateUserController());
  }

  final ImagePicker picker = ImagePicker();

  XFile? imageFile;

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: GetBuilder(
        init: controller,
        builder: (controller) {
          return Column(
            children: [
              Padding(
                padding: MySpacing.x(flexSpacing),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText.titleMedium(
                      "New User",
                      fontWeight: 600,
                    ),
                    MyBreadcrumb(
                      children: [
                        MyBreadcrumbItem(name: "Users"),
                        MyBreadcrumbItem(name: "New User", active: true),
                      ],
                    ),
                  ],
                ),
              ),
              MySpacing.height(flexSpacing),
              Padding(
                padding: MySpacing.x(flexSpacing / 2),
                child: MyFlex(
                  children: [
                    MyFlexItem(
                      sizes: "lg-6",
                      child: MyCard(
                        shadow: MyShadow(elevation: 0.5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () async {
                                imageFile = await picker.pickImage(
                                  source: ImageSource.gallery,
                                );
                                debugPrint(
                                  "imageFile!.path --------------------->>> ${imageFile!.path}",
                                );
                                setState(() {});
                              },
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  imageFile == null
                                      ? MyContainer.rounded(
                                          height: 150,
                                          width: 150,
                                          paddingAll: 0,
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          child: Image.asset(
                                            Images.avatars[0],
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : MyContainer.rounded(
                                          paddingAll: 0,
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          child: Image.file(
                                            File(imageFile!.path),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                            MySpacing.height(20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  controller: controller.displayNameController,
                                  decoration: InputDecoration(
                                    labelText: 'Display Name',
                                    hintText: 'Enter display name',
                                  ),
                                  validator: controller.validateDisplayName,
                                ),
                                MySpacing.height(20),
                                TextFormField(
                                  controller: controller.emailController,
                                  decoration: InputDecoration(
                                    labelText: 'Email address',
                                    hintText: 'Enter Email Address',
                                    hintStyle:
                                        MyTextStyle.bodySmall(xMuted: true),
                                    border: outlineInputBorder,
                                    enabledBorder: outlineInputBorder,
                                    focusedBorder: focusedInputBorder,
                                    contentPadding: MySpacing.all(16),
                                    isCollapsed: true,
                                  ),
                                  validator: controller.validateEmail,
                                ),
                                MySpacing.height(20),
                                TextFormField(
                                  controller: controller.passwordController,
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: !controller.showPassword,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    hintText: 'Password',
                                    hintStyle:
                                        MyTextStyle.bodySmall(xMuted: true),
                                    border: outlineInputBorder,
                                    enabledBorder: outlineInputBorder,
                                    focusedBorder: focusedInputBorder,
                                    suffixIcon: InkWell(
                                      onTap: controller.onChangeShowPassword,
                                      child: Icon(
                                        controller.showPassword
                                            ? LucideIcons.eye
                                            : LucideIcons.eyeOff,
                                        size: 18,
                                      ),
                                    ),
                                    contentPadding: MySpacing.all(16),
                                    isCollapsed: true,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                  ),
                                  validator: controller.validatePassword,
                                ),
                                MySpacing.height(20),
                                MyButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Confirmation"),
                                          content: Text(
                                            "Are you sure you want to create this user?",
                                          ),
                                          actions: [
                                            TextButton(
                                              child: Text("Cancel"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text("Create"),
                                              onPressed: () {
                                                controller.createUser();
                                                // Perform create user action here
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  elevation: 0,
                                  padding: MySpacing.xy(20, 16),
                                  backgroundColor: contentTheme.primary,
                                  borderRadiusAll: AppStyle.buttonRadius.medium,
                                  child: MyText.bodySmall(
                                    'Create',
                                    color: contentTheme.onPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildTextField(String fieldTitle, String hintText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText.labelMedium(
          fieldTitle,
        ),
        MySpacing.height(8),
        TextFormField(
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: MyTextStyle.bodySmall(xMuted: true),
            border: outlineInputBorder,
            contentPadding: MySpacing.all(16),
            isCollapsed: true,
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
        ),
      ],
    );
  }
}

class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'\D'), '');

    return newValue.copyWith(
      text: text.isNotEmpty ? text : '',
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
