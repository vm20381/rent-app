import 'package:captainapp_crew_dashboard/controller/admin/users/user_list_controller.dart';
import 'package:captainapp_crew_dashboard/helpers/storage/firebase_storage.dart';
import 'package:captainapp_crew_dashboard/models/firebase_auth_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:captainapp_crew_dashboard/helpers/theme/app_style.dart';
import 'package:captainapp_crew_dashboard/helpers/utils/my_shadow.dart';
import 'package:captainapp_crew_dashboard/helpers/utils/ui_mixins.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_breadcrumb.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_breadcrumb_item.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_button.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_card.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_container.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_spacing.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_text.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_text_style.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/responsive.dart';
import 'package:captainapp_crew_dashboard/views/layouts/layout.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  State<UserList> createState() => UserListState();
}

class UserListState extends State<UserList>
    with SingleTickerProviderStateMixin, UIMixin {
  late UserListController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(UserListController());
  }

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
                      "",
                      // "Users List",
                      fontWeight: 600,
                    ),
                    MyBreadcrumb(
                      children: [
                        MyBreadcrumbItem(name: "Admin"),
                        MyBreadcrumbItem(name: "Users", active: true),
                      ],
                    ),
                  ],
                ),
              ),
              MySpacing.height(flexSpacing),
              Padding(
                padding: MySpacing.x(flexSpacing),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyButton(
                          onPressed: () => {
                            Get.toNamed('/admin/create-user'),
                          },
                          elevation: 0,
                          padding: MySpacing.xy(12, 16),
                          backgroundColor: contentTheme.primary,
                          borderRadiusAll: AppStyle.buttonRadius.medium,
                          child: Row(
                            children: [
                              Icon(
                                LucideIcons.plusCircle,
                                color: contentTheme.light,
                                size: 16,
                              ),
                              MySpacing.width(16),
                              MyText.bodySmall(
                                "Add New",
                                color: contentTheme.onPrimary,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: TextFormField(
                            maxLines: 1,
                            style: MyTextStyle.bodyMedium(),
                            decoration: InputDecoration(
                              hintText: "search",
                              hintStyle: MyTextStyle.bodySmall(xMuted: true),
                              border: outlineInputBorder,
                              enabledBorder: outlineInputBorder,
                              focusedBorder: focusedInputBorder,
                              prefixIcon: const Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  LucideIcons.search,
                                  size: 14,
                                ),
                              ),
                              prefixIconConstraints: const BoxConstraints(
                                minWidth: 36,
                                maxWidth: 36,
                                minHeight: 32,
                                maxHeight: 32,
                              ),
                              contentPadding: MySpacing.xy(16, 12),
                              isCollapsed: true,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                            ),
                          ),
                        ),
                      ],
                    ),
                    MySpacing.height(flexSpacing),
                    GridView.builder(
                      shrinkWrap: true,
                      itemCount: controller.users.length,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 350,
                        // childAspectRatio: 1,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        mainAxisExtent: 320,
                      ),
                      itemBuilder: (context, index) {
                        final user = controller.users[index];
                        return MyCard(
                          shadow: MyShadow(elevation: 0.5),
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              MyContainer.none(
                                paddingAll: 8,
                                borderRadiusAll: 5,
                                child: PopupMenuButton(
                                  offset: const Offset(0, 10),
                                  position: PopupMenuPosition.under,
                                  itemBuilder: (BuildContext context) => [
                                    PopupMenuItem(
                                      padding: MySpacing.xy(16, 8),
                                      height: 10,
                                      child: MyText.bodySmall("Action"),
                                    ),
                                    PopupMenuItem(
                                      padding: MySpacing.xy(16, 8),
                                      height: 10,
                                      child: MyText.bodySmall("Another action"),
                                    ),
                                    PopupMenuItem(
                                      padding: MySpacing.xy(16, 8),
                                      height: 10,
                                      child: MyText.bodySmall(
                                        "Somethings else here",
                                      ),
                                    ),
                                  ],
                                  child: const Icon(
                                    LucideIcons.moreVertical,
                                    size: 18,
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  MyContainer.roundBordered(
                                    paddingAll: 4,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: MyContainer.rounded(
                                      height: 100,
                                      paddingAll: 0,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      child: ImageFromStorage(
                                        imagePath: user.photoURL,
                                      ),
                                      // Image(
                                      //   image: NetworkImage(
                                      //     user.photoURL,
                                      //   ),
                                      //   fit: BoxFit.cover,
                                      // ),
                                    ),
                                  ),
                                  MyText.bodyMedium(
                                    user.displayName,
                                    fontSize: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        LucideIcons.mail,
                                        size: 16,
                                      ),
                                      MySpacing.width(8),
                                      MyText.bodyMedium(
                                        user.email,
                                        fontSize: 16,
                                        fontWeight: 500,
                                        muted: true,
                                      ),
                                    ],
                                  ),
                                  MyText.bodyMedium(
                                    user.role,
                                    fontSize: 16,
                                    muted: true,
                                  ),
                                  DropdownButton<String>(
                                    value: user.role == '' ? null : user.role,
                                    hint: const Text('Assign Role'),
                                    icon: const Icon(Icons.arrow_downward),
                                    elevation: 16,
                                    style: const TextStyle(
                                      color: Colors.deepPurple,
                                    ),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                    onChanged: (String? newValue) {
                                      if (newValue != null &&
                                          newValue != user.role) {
                                        _showRoleChangeDialog(
                                          user,
                                          newValue,
                                        );
                                      }
                                    },
                                    items: <String>[
                                      'admin',
                                      'manager',
                                      'vendor',
                                      'customer',
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      // IconButton(
                                      //   onPressed: () {},
                                      //   icon: const Icon(
                                      //     LucideIcons.linkedin,
                                      //     color: Color(0xff0A66C2),
                                      //     size: 20,
                                      //   ),
                                      // ),
                                      // IconButton(
                                      //   onPressed: () {},
                                      //   icon: const Icon(
                                      //     LucideIcons.facebook,
                                      //     color: Color(0xff3b5998),
                                      //     size: 20,
                                      //   ),
                                      // ),
                                      // IconButton(
                                      //   onPressed: () {},
                                      //   icon: const Icon(
                                      //     LucideIcons.github,
                                      //     color: Color(0xff3b5998),
                                      //     size: 20,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
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

  void _showRoleChangeDialog(FirebaseAuthUser user, String newRole) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Role Change'),
        content: Text('Change ${user.displayName}\'s role to $newRole?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              controller.setUserRole(user.id, newRole);
            },
            child: Text('Confirm'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
