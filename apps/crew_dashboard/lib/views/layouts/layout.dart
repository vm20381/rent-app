import 'package:captainapp_crew_dashboard/helpers/widgets/my_flex.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_flex_item.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_text_style.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:captainapp_crew_dashboard/controller/layouts/layout_controller.dart';
import 'package:captainapp_crew_dashboard/helpers/theme/admin_theme.dart';
import 'package:captainapp_crew_dashboard/helpers/theme/app_style.dart';
import 'package:captainapp_crew_dashboard/helpers/theme/app_theme.dart';
import 'package:captainapp_crew_dashboard/helpers/theme/theme_customizer.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_button.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_container.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_dashed_divider.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_responsiv.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_spacing.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_text.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/responsive.dart';
import 'package:captainapp_crew_dashboard/images.dart';
import 'package:captainapp_crew_dashboard/views/layouts/left_bar.dart';
import 'package:captainapp_crew_dashboard/views/layouts/right_bar.dart';
import 'package:captainapp_crew_dashboard/views/layouts/top_bar.dart';
import 'package:captainapp_crew_dashboard/widgets/custom_pop_menu.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

class Layout extends StatelessWidget {
  final Widget? child;

  final LayoutController controller = LayoutController();
  final topBarTheme = AdminTheme.theme.topBarTheme;
  final contentTheme = AdminTheme.theme.contentTheme;

  Layout({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return MyResponsive(
      builder: (BuildContext context, _, screenMT) {
        return GetBuilder(
          init: controller,
          builder: (controller) {
            return screenMT.isMobile
                ? mobileScreen(context)
                : largeScreen(context);
          },
        );
      },
    );
  }

  Widget mobileScreen(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        actions: [
          InkWell(
            onTap: () {
              ThemeCustomizer.setTheme(
                ThemeCustomizer.instance.theme == ThemeMode.dark
                    ? ThemeMode.light
                    : ThemeMode.dark,
              );
            },
            child: Icon(
              ThemeCustomizer.instance.theme == ThemeMode.dark
                  ? FeatherIcons.sun
                  : FeatherIcons.moon,
              size: 18,
              color: topBarTheme.onBackground,
            ),
          ),
          MySpacing.width(8),
          CustomPopupMenu(
            backdrop: true,
            onChange: (_) {},
            offsetX: -180,
            menu: Padding(
              padding: MySpacing.xy(8, 8),
              child: Center(
                child: Icon(
                  FeatherIcons.bell,
                  size: 18,
                ),
              ),
            ),
            menuBuilder: (_) => buildNotifications(),
          ),
          MySpacing.width(8),
          CustomPopupMenu(
            backdrop: true,
            onChange: (_) {},
            offsetX: -90,
            offsetY: 4,
            menu: Padding(
              padding: MySpacing.xy(8, 8),
              child: MyContainer.rounded(
                paddingAll: 0,
                child: Image.asset(
                  Images.avatars[0],
                  height: 28,
                  width: 28,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            menuBuilder: (_) => buildAccountMenu(),
          ),
          MySpacing.width(20),
        ],
      ), // endDrawer: RightBar(),
      // extendBodyBehindAppBar: true,
      // appBar: TopBar(
      drawer: LeftBar(),
      body: SingleChildScrollView(
        key: controller.scrollKey,
        child: child,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _handleFeedback(context),
        backgroundColor: AdminTheme.theme.contentTheme.primary,
        child: Icon(FeatherIcons.messageSquare),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget largeScreen(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      endDrawer: RightBar(),
      body: Row(
        children: [
          LeftBar(isCondensed: ThemeCustomizer.instance.leftBarCondensed),
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  bottom: 0,
                  child: SingleChildScrollView(
                    padding:
                        MySpacing.fromLTRB(0, 58 + flexSpacing, 0, flexSpacing),
                    key: controller.scrollKey,
                    child: child,
                  ),
                ),
                Positioned(top: 0, left: 0, right: 0, child: TopBar()),
              ],
            ),
          ),
          // Expanded(
          //     child: Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     TopBar(),
          //     Expanded(
          //         child: SingleChildScrollView(
          //       padding: MySpacing.y(flexSpacing),
          //       key: controller.scrollKey,
          //       child: child,
          //     )),
          //   ],
          // ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _handleFeedback(context),
        backgroundColor: AdminTheme.theme.contentTheme.primary,
        child: Icon(FeatherIcons.messageSquare),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget buildNotifications() {
    Widget buildNotification(String title, String description) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText.labelLarge(title),
          MySpacing.height(4),
          MyText.bodySmall(description),
        ],
      );
    }

    return MyContainer.bordered(
      paddingAll: 0,
      width: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: MySpacing.xy(16, 12),
            child: MyText.titleMedium("Notification", fontWeight: 600),
          ),
          MyDashedDivider(
            height: 1,
            color: theme.dividerColor,
            dashSpace: 4,
            dashWidth: 6,
          ),
          Padding(
            padding: MySpacing.xy(16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildNotification(
                  "Your order is received",
                  "Order #1232 is ready to deliver",
                ),
                MySpacing.height(12),
                buildNotification(
                  "Account Security ",
                  "Your account password changed 1 hour ago",
                ),
              ],
            ),
          ),
          MyDashedDivider(
            height: 1,
            color: theme.dividerColor,
            dashSpace: 4,
            dashWidth: 6,
          ),
          Padding(
            padding: MySpacing.xy(16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyButton.text(
                  onPressed: () {},
                  splashColor: contentTheme.primary.withAlpha(28),
                  child: MyText.labelSmall(
                    "View All",
                    color: contentTheme.primary,
                  ),
                ),
                MyButton.text(
                  onPressed: () {},
                  splashColor: contentTheme.danger.withAlpha(28),
                  child: MyText.labelSmall(
                    "Clear",
                    color: contentTheme.danger,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAccountMenu() {
    return MyContainer.bordered(
      paddingAll: 0,
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: MySpacing.xy(8, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyButton(
                  onPressed: () => {},
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  borderRadiusAll: AppStyle.buttonRadius.medium,
                  padding: MySpacing.xy(8, 4),
                  splashColor: theme.colorScheme.onBackground.withAlpha(20),
                  backgroundColor: Colors.transparent,
                  child: Row(
                    children: [
                      Icon(
                        FeatherIcons.user,
                        size: 14,
                        color: contentTheme.onBackground,
                      ),
                      MySpacing.width(8),
                      MyText.labelMedium(
                        "My Account",
                        fontWeight: 600,
                      ),
                    ],
                  ),
                ),
                MySpacing.height(4),
                MyButton(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onPressed: () => {},
                  borderRadiusAll: AppStyle.buttonRadius.medium,
                  padding: MySpacing.xy(8, 4),
                  splashColor: theme.colorScheme.onBackground.withAlpha(20),
                  backgroundColor: Colors.transparent,
                  child: Row(
                    children: [
                      Icon(
                        FeatherIcons.settings,
                        size: 14,
                        color: contentTheme.onBackground,
                      ),
                      MySpacing.width(8),
                      MyText.labelMedium(
                        "Settings",
                        fontWeight: 600,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
          ),
          Padding(
            padding: MySpacing.xy(8, 8),
            child: MyButton(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: () => controller.logout(),
              borderRadiusAll: AppStyle.buttonRadius.medium,
              padding: MySpacing.xy(8, 4),
              splashColor: contentTheme.danger.withAlpha(28),
              backgroundColor: Colors.transparent,
              child: Row(
                children: [
                  Icon(
                    FeatherIcons.logOut,
                    size: 14,
                    color: contentTheme.danger,
                  ),
                  MySpacing.width(8),
                  MyText.labelMedium(
                    "Log out",
                    fontWeight: 600,
                    color: contentTheme.danger,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleFeedback(BuildContext context) {
    // You can implement this method to open a feedback form or dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Feedback"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("page: ${Get.currentRoute}"),
              SizedBox(
                height: 400,
                width: 400,
                child: Padding(
                  padding: MySpacing.x(flexSpacing),
                  child: MyFlex(
                    children: [
                      MyFlexItem(
                        sizes: "lg-8",
                        child: Column(
                          children: [
                            ToolBar(
                              padding: const EdgeInsets.all(8),
                              iconSize: 20,
                              controller: controller.quillHtmlEditor,
                              toolBarConfig: controller.customToolBarList,
                            ),
                            QuillHtmlEditor(
                              text:
                                  "Hello This is a quill html editor example 😊",
                              hintText: 'Hint text goes here',
                              controller: controller.quillHtmlEditor,
                              isEnabled: true,
                              minHeight: 300,
                              hintTextAlign: TextAlign.start,
                              textStyle: MyTextStyle.bodySmall(),
                              padding: const EdgeInsets.only(left: 10, top: 5),
                              hintTextPadding: EdgeInsets.zero,
                              backgroundColor: contentTheme.background,
                              onFocusChanged: (hasFocus) =>
                                  debugPrint('has focus $hasFocus'),
                              onTextChanged: (text) =>
                                  debugPrint('widget text change $text'),
                              onEditorCreated: () =>
                                  debugPrint('Editor has been loaded'),
                              onEditorResized: (height) =>
                                  debugPrint('Editor resized $height'),
                              onSelectionChanged: (sel) => debugPrint(
                                '${sel.index},${sel.length}',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Submit'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
