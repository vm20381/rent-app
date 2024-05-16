import '/helpers/theme/admin_theme.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../controllers/layouts/top_bar_controller.dart';
import '/helpers/localizations/language.dart';
import '/helpers/storage/firebase_storage.dart';
import '/helpers/theme/app_notifier.dart';
import '/helpers/theme/app_style.dart';
import '/helpers/theme/app_theme.dart';
import '/helpers/theme/theme_customizer.dart';
import '/helpers/utils/my_shadow.dart';
import '/helpers/utils/ui_mixins.dart';
import '/helpers/widgets/my_button.dart';
import '/helpers/widgets/my_card.dart';
import '/helpers/widgets/my_container.dart';
import '/helpers/widgets/my_dashed_divider.dart';
import '/helpers/widgets/my_spacing.dart';
import '/helpers/widgets/my_text.dart';
import '/helpers/widgets/my_text_style.dart';
import '/widgets/custom_pop_menu.dart';

class TopBar extends StatefulWidget {
  const TopBar({
    super.key, // this.onMenuIconTap,
  });

  @override
  _TopBarState createState() => _TopBarState();
}

class _TopBarState extends State<TopBar>
    with SingleTickerProviderStateMixin, UIMixin {
  late TopBarController controller;
  Function? languageHideFn;

  @override
  void initState() {
    super.initState();
    controller = Get.put(TopBarController());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppNotifier>(
      // ? Note that this consumer is not used in the crew dashboard.
      // Bonus to anyone who finds what it is we broke in stripping out for the example that makes this consumer necessary.
      builder: (context, appNotifier, child) {
        return MyCard(
          shadow:
              MyShadow(position: MyShadowPosition.bottomRight, elevation: 0.5),
          height: 60,
          borderRadiusAll: 0,
          padding: MySpacing.x(24),
          color: topBarTheme.background.withAlpha(246),
          child: Row(
            children: [
              Row(
                children: [
                  InkWell(
                    splashColor: theme.colorScheme.onBackground,
                    highlightColor: theme.colorScheme.onBackground,
                    onTap: () {
                      ThemeCustomizer.toggleLeftBarCondensed();
                    },
                    child: Icon(
                      LucideIcons.menu,
                      color: topBarTheme.onBackground,
                    ),
                  ),
                  MySpacing.width(24),
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
                            FeatherIcons.search,
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
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
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
                    MySpacing.width(12),
                    CustomPopupMenu(
                      backdrop: true,
                      hideFn: (_) => languageHideFn = _,
                      onChange: (_) {},
                      offsetX: -36,
                      menu: Padding(
                        padding: MySpacing.xy(8, 8),
                        child: Center(
                          child: ClipRRect(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            borderRadius: BorderRadius.circular(2),
                            child: Image.asset(
                              "assets/lang/${ThemeCustomizer.instance.currentLanguage.locale.languageCode}.jpg",
                              width: 24,
                              height: 18,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      menuBuilder: (_) => buildLanguageSelector(),
                    ),
                    MySpacing.width(6),
                    CustomPopupMenu(
                      backdrop: true,
                      onChange: (_) {},
                      offsetX: -120,
                      menu: Padding(
                        padding: MySpacing.xy(8, 8),
                        child: const Center(
                          child: Icon(
                            FeatherIcons.bell,
                            size: 18,
                          ),
                        ),
                      ),
                      menuBuilder: (_) => buildNotifications(),
                    ),
                    MySpacing.width(4),
                    CustomPopupMenu(
                      backdrop: true,
                      onChange: (_) {},
                      offsetX: -60,
                      offsetY: 8,
                      menu: Padding(
                        padding: MySpacing.xy(8, 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            MyContainer.rounded(
                              paddingAll: 0,
                              child: Obx(
                                () => ImageFromStorage(
                                  imagePath: controller.photoURL.value,
                                ),
                              ),
                            ),
                            MySpacing.width(8),
                            Obx(
                              () => MyText.labelLarge(
                                controller.displayName.value.split(' ').first,
                              ),
                            ),
                          ],
                        ),
                      ),
                      menuBuilder: (_) => buildAccountMenu(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildLanguageSelector() {
    return MyContainer.bordered(
      padding: MySpacing.xy(8, 8),
      width: 125,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: Language.languages
            .map(
              (language) => MyButton.text(
                padding: MySpacing.xy(8, 4),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                splashColor: contentTheme.onBackground.withAlpha(20),
                onPressed: () async {
                  languageHideFn?.call();
                  // Language.changeLanguage(language);
                  await Provider.of<AppNotifier>(context, listen: false)
                      .changeLanguage(language, notify: true);
                  ThemeCustomizer.notify();
                  setState(() {});
                },
                child: Row(
                  children: [
                    ClipRRect(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      borderRadius: BorderRadius.circular(2),
                      child: Image.asset(
                        "assets/lang/${language.locale.languageCode}.jpg",
                        width: 18,
                        height: 14,
                        fit: BoxFit.cover,
                      ),
                    ),
                    MySpacing.width(8),
                    MyText.labelMedium(language.languageName),
                  ],
                ),
              ),
            )
            .toList(),
      ),
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
                  "Good Day Crew!",
                  "Welcome aboard, the ship will be casting off in 30 minutes",
                ),
                MySpacing.height(12),
                buildNotification(
                  "Security Announcement",
                  "There are no life vests on board, so don't fall in",
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
                  onPressed: () {
                    Get.toNamed('/my-profile');
                    setState(() {});
                  },
                  // onPressed: () =>
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
                        "My Profile",
                        fontWeight: 600,
                      ),
                    ],
                  ),
                ),
                // MySpacing.height(4),
                // MyButton(
                //   tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                //   onPressed: () {
                //     Get.toNamed('/contacts/edit-profile');
                //     setState(() {});
                //   },
                //   borderRadiusAll: AppStyle.buttonRadius.medium,
                //   padding: MySpacing.xy(8, 4),
                //   splashColor: theme.colorScheme.onBackground.withAlpha(20),
                //   backgroundColor: Colors.transparent,
                //   child: Row(
                //     children: [
                //       Icon(
                //         FeatherIcons.edit,
                //         size: 14,
                //         color: contentTheme.onBackground,
                //       ),
                //       MySpacing.width(8),
                //       MyText.labelMedium(
                //         "Edit Profile",
                //         fontWeight: 600,
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
          const Divider(
            height: 1,
            thickness: 1,
          ),
          Padding(
            padding: MySpacing.xy(8, 8),
            child: MyButton(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: () {
                controller.logout();
              },
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

  @override
  void dispose() {
    Get.delete<TopBarController>();
    super.dispose();
  }
}
