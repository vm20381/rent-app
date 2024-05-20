import 'package:captainapp_crew_dashboard/controller/me/edit_user_profile_controller.dart';
import 'package:captainapp_crew_dashboard/helpers/storage/firebase_storage.dart';
import 'package:captainapp_crew_dashboard/helpers/utils/my_shadow.dart';
import 'package:captainapp_crew_dashboard/helpers/utils/ui_mixins.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_breadcrumb.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_breadcrumb_item.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_card.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_container.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_flex.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_flex_item.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_spacing.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_text.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_text_style.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/responsive.dart';
import 'package:captainapp_crew_dashboard/views/layouts/layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditUserProfile extends StatefulWidget {
  const EditUserProfile({super.key});

  @override
  State<EditUserProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditUserProfile>
    with SingleTickerProviderStateMixin, UIMixin {
  late EditUserProfileController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(EditUserProfileController());
  }

  // final ImagePicker picker = ImagePicker();

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
                    const MyText.titleMedium(
                      "My Profile",
                      fontWeight: 600,
                    ),
                    MyBreadcrumb(
                      children: [
                        MyBreadcrumbItem(name: "Me"),
                        MyBreadcrumbItem(name: "Edit Profile", active: true),
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
                              onTap: controller.handleImageSelection,
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  MyContainer.rounded(
                                    height: 150, // Set a fixed height
                                    width: 150, // Set a fixed width
                                    paddingAll: 0,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: ImageFromStorage(
                                      imagePath:
                                          // "/profileImages/B1Lr5HQ0rVQNkiVrxoPGepHMQ453/test.jpg",
                                          controller.userProfilePictureUrl,
                                    ),
                                    // Image(
                                    //   image: NetworkImage(
                                    //     controller.userProfilePictureUrl,
                                    //   ),
                                    //   fit: BoxFit.cover,
                                    // ),
                                  ),
                                ],
                              ),
                            ),
                            MySpacing.height(20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Divider(height: 40),
                                Text(
                                  'Name: ${controller.authService.user?.displayName ?? "N/A"}',
                                  style: const TextStyle(fontSize: 20),
                                ),
                                OutlinedButton(
                                  onPressed: () => _editName(context),
                                  child: const Text('Edit Name'),
                                ),
                                const Divider(height: 40),
                                Text(
                                  'Email: ${controller.authService.user?.email ?? "N/A"}',
                                  style: const TextStyle(fontSize: 20),
                                ),
                                const Divider(height: 40),
                                OutlinedButton(
                                  onPressed:
                                      controller.togglePasswordVisibility,
                                  child: const Text('Set New Password'),
                                ),
                                // buildTextField(
                                //   "First Name",
                                //   "Enter your First Name",
                                // ),
                                // MySpacing.height(20),
                                // buildTextField(
                                //   "Last Name",
                                //   "Enter your Last Name",
                                // ),
                                // MySpacing.height(20),
                                // MyText.labelMedium(
                                //   "Email address",
                                // ),
                                // MySpacing.height(8),
                                // Form(
                                //   autovalidateMode:
                                //       AutovalidateMode.onUserInteraction,
                                //   child: TextFormField(
                                //     validator: (value) {
                                //       if (value != null && value.isEmpty) {
                                //         return 'Email is required';
                                //       }
                                //       if (value != null &&
                                //           !MyStringUtils.isEmail(value)) {
                                //         return 'Invalid Email';
                                //       }
                                //       return null;
                                //     },
                                //     decoration: InputDecoration(
                                //       hintText: "Enter Email Address",
                                //       hintStyle:
                                //           MyTextStyle.bodySmall(xMuted: true),
                                //       border: outlineInputBorder,
                                //       enabledBorder: outlineInputBorder,
                                //       focusedBorder: focusedInputBorder,
                                //       contentPadding: MySpacing.all(16),
                                //       isCollapsed: true,
                                //     ),
                                //   ),
                                // ),
                                // MySpacing.height(20),
                                // MyText.labelMedium(
                                //   "password",
                                // ),
                                // MySpacing.height(8),
                                // TextFormField(
                                //   validator: controller.validation
                                //       .getValidation('password'),
                                //   controller: controller.validation
                                //       .getController('password'),
                                //   keyboardType: TextInputType.visiblePassword,
                                //   obscureText: !controller.showPassword,
                                //   decoration: InputDecoration(
                                //     hintText: "Password",
                                //     hintStyle:
                                //         MyTextStyle.bodySmall(xMuted: true),
                                //     border: outlineInputBorder,
                                //     enabledBorder: outlineInputBorder,
                                //     focusedBorder: focusedInputBorder,
                                //     suffixIcon: InkWell(
                                //       onTap:
                                //           controller.togglePasswordVisibility,
                                //       child: Icon(
                                //         controller.showPassword
                                //             ? LucideIcons.eye
                                //             : LucideIcons.eyeOff,
                                //         size: 18,
                                //       ),
                                //     ),
                                //     contentPadding: MySpacing.all(16),
                                //     isCollapsed: true,
                                //     floatingLabelBehavior:
                                //         FloatingLabelBehavior.never,
                                //   ),
                                // ),
                                // MySpacing.height(20),
                                // MyButton(
                                //   onPressed: () {},
                                //   elevation: 0,
                                //   padding: MySpacing.xy(20, 16),
                                //   backgroundColor: contentTheme.primary,
                                //   borderRadiusAll: AppStyle.buttonRadius.medium,
                                //   child: MyText.bodySmall(
                                //     'Save',
                                //     color: contentTheme.onPrimary,
                                //   ),
                                // ),
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

void _editName(BuildContext context) {
  final controller = Get.find<EditUserProfileController>();
  // Use TextEditingController to manage form fields.
  final firstNameController = TextEditingController(
    text: controller.validation.getController('First Name')?.text,
  );
  final lastNameController = TextEditingController(
    text: controller.validation.getController('Last Name')?.text,
  );

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Edit Name'),
      content: Form(
        key: controller.validation
            .formKey, // Assign the GlobalKey<FormState> from the controller
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
              validator: (value) => controller.validation
                  .getValidation<String>('First Name')
                  ?.call(value),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              autofocus: true,
            ),
            TextFormField(
              controller: lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
              validator: (value) => controller.validation
                  .getValidation<String>('Last Name')
                  ?.call(value),
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Validate the form using the GlobalKey<FormState>
            if (controller.validation.formKey.currentState!.validate()) {
              controller.validation.getController('First Name')?.text =
                  firstNameController.text;
              controller.validation.getController('Last Name')?.text =
                  lastNameController.text;
              Navigator.of(context).pop();
              controller.updateProfile();
            } else {
              Get.snackbar('Error', 'Please check your inputs');
            }
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}
