import 'package:captainapp_crew_dashboard/app_constant.dart';
import 'package:captainapp_crew_dashboard/controller/apps/entities/create_entity_controller.dart';
import 'package:captainapp_crew_dashboard/helpers/theme/app_style.dart';
import 'package:captainapp_crew_dashboard/helpers/theme/app_theme.dart';
import 'package:captainapp_crew_dashboard/helpers/utils/my_shadow.dart';
import 'package:captainapp_crew_dashboard/helpers/utils/ui_mixins.dart';
import 'package:captainapp_crew_dashboard/helpers/utils/utils.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_breadcrumb.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_breadcrumb_item.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_button.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_card.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_container.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_dotted_line.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_flex.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_flex_item.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_list_extension.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_spacing.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_text.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_text_style.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/responsive.dart';
import 'package:captainapp_crew_dashboard/views/layouts/layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CreateEntity extends StatefulWidget {
  const CreateEntity({super.key});

  @override
  State<CreateEntity> createState() => CreateEntitiesState();
}

class CreateEntitiesState extends State<CreateEntity>
    with SingleTickerProviderStateMixin, UIMixin {
  late CreateProjectController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(CreateProjectController());
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
                    const MyText.titleMedium(
                      "Create Project",
                      fontSize: 18,
                      fontWeight: 600,
                    ),
                    MyBreadcrumb(
                      children: [
                        MyBreadcrumbItem(name: 'entities'),
                        MyBreadcrumbItem(name: 'Create Project', active: true),
                      ],
                    ),
                  ],
                ),
              ),
              MySpacing.height(flexSpacing),
              Padding(
                padding: MySpacing.x(flexSpacing),
                child: MyCard(
                  shadow: MyShadow(elevation: 0.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyFlex(
                        contentPadding: false,
                        children: [
                          MyFlexItem(
                            sizes: "lg-6",
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildTextField(
                                  "Project Name",
                                  "Enter Project Name",
                                ),
                                MySpacing.height(16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const MyText.bodyMedium(
                                      "Project OverView",
                                      fontWeight: 600,
                                      muted: true,
                                    ),
                                    MySpacing.height(8),
                                    TextFormField(
                                      keyboardType: TextInputType.multiline,
                                      maxLines: 3,
                                      decoration: InputDecoration(
                                        hintText:
                                            "Enter Some Brief About Project",
                                        hintStyle:
                                            MyTextStyle.bodySmall(xMuted: true),
                                        border: outlineInputBorder,
                                        contentPadding: MySpacing.all(16),
                                        isCollapsed: true,
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                      ),
                                    ),
                                  ],
                                ),
                                MySpacing.height(16),
                                Wrap(
                                  spacing: 16,
                                  children: ProjectPrivacy.values
                                      .map(
                                        (value) => InkWell(
                                          onTap: () => controller
                                              .onChangeProjectPrivacy(value),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Radio<ProjectPrivacy>(
                                                value: value,
                                                activeColor:
                                                    contentTheme.primary,
                                                groupValue: controller
                                                    .selectProjectPrivacy,
                                                onChanged: controller
                                                    .onChangeProjectPrivacy,
                                                visualDensity:
                                                    getCompactDensity,
                                                materialTapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                              ),
                                              MySpacing.width(8),
                                              MyText.labelMedium(value.name),
                                            ],
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                                MySpacing.height(16),
                                MyFlex(
                                  contentPadding: false,
                                  children: [
                                    MyFlexItem(
                                      sizes: "lg-6",
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const MyText.bodyMedium(
                                            "Start Date",
                                            fontWeight: 600,
                                            muted: true,
                                          ),
                                          MySpacing.height(8),
                                          MyContainer.bordered(
                                            paddingAll: 12,
                                            onTap: () {
                                              controller.pickStartDate();
                                            },
                                            borderColor:
                                                theme.colorScheme.secondary,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Icon(
                                                  LucideIcons.calendar,
                                                  color: theme
                                                      .colorScheme.secondary,
                                                  size: 16,
                                                ),
                                                MySpacing.width(10),
                                                MyText.bodyMedium(
                                                  controller.selectedStartDate !=
                                                          null
                                                      ? dateFormatter.format(
                                                          controller
                                                              .selectedStartDate!,
                                                        )
                                                      : "1/10/2020",
                                                  fontWeight: 600,
                                                  color: theme
                                                      .colorScheme.secondary,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    MyFlexItem(
                                      sizes: "lg-6",
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const MyText.bodyMedium(
                                            "End Date",
                                            fontWeight: 600,
                                            muted: true,
                                          ),
                                          MySpacing.height(8),
                                          MyContainer.bordered(
                                            paddingAll: 12,
                                            onTap: () {
                                              controller.pickEndDate();
                                            },
                                            borderColor:
                                                theme.colorScheme.secondary,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Icon(
                                                  LucideIcons.calendar,
                                                  color: theme
                                                      .colorScheme.secondary,
                                                  size: 16,
                                                ),
                                                MySpacing.width(10),
                                                MyText.bodyMedium(
                                                  controller.selectedEndDate !=
                                                          null
                                                      ? dateFormatter.format(
                                                          controller
                                                              .selectedEndDate!,
                                                        )
                                                      : "1/10/2020",
                                                  fontWeight: 600,
                                                  color: theme
                                                      .colorScheme.secondary,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                MySpacing.height(16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const MyText.bodyMedium(
                                      "Project Priority",
                                      fontWeight: 600,
                                      muted: true,
                                    ),
                                    MySpacing.height(8),
                                    PopupMenuButton(
                                      itemBuilder: (BuildContext context) {
                                        return [
                                          "Medium",
                                          "High",
                                          "Low",
                                        ].map((behavior) {
                                          return PopupMenuItem(
                                            value: behavior,
                                            height: 32,
                                            child: MyText.bodySmall(
                                              behavior.toString(),
                                              color: theme
                                                  .colorScheme.onSurface,
                                              fontWeight: 600,
                                            ),
                                          );
                                        }).toList();
                                      },
                                      offset: const Offset(0, 40),
                                      onSelected: controller.onSelectedSize,
                                      color: theme.cardTheme.color,
                                      child: MyContainer.bordered(
                                        paddingAll: 8,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            MyText.labelMedium(
                                              controller.selectProperties
                                                  .toString(),
                                              color: theme
                                                  .colorScheme.onSurface,
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                left: 4,
                                              ),
                                              child: Icon(
                                                LucideIcons.chevronDown,
                                                size: 22,
                                                color: theme
                                                    .colorScheme.onSurface,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                MySpacing.height(16),
                                buildTextField(
                                  "Budget",
                                  "Enter Project Budget",
                                ),
                              ],
                            ),
                          ),
                          MyFlexItem(
                            sizes: "lg-6",
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: controller.pickFile,
                                  child: MyDottedLine(
                                    strokeWidth: 0.2,
                                    color: contentTheme.onBackground,
                                    corner: const MyDottedLineCorner(
                                      leftBottomCorner: 2,
                                      leftTopCorner: 2,
                                      rightBottomCorner: 2,
                                      rightTopCorner: 2,
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: MySpacing.xy(12, 44),
                                        child: const Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(LucideIcons.uploadCloud),
                                            MyContainer(
                                              width: 340,
                                              alignment: Alignment.center,
                                              paddingAll: 0,
                                              child: MyText.titleMedium(
                                                "Drop files here or click to upload.",
                                                fontWeight: 600,
                                                muted: true,
                                                fontSize: 18,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (controller.files.isNotEmpty) ...[
                                  MySpacing.height(16),
                                  Wrap(
                                    runSpacing: 16,
                                    spacing: 16,
                                    children: controller.files
                                        .mapIndexed(
                                          (index, file) => MyContainer(
                                            color: contentTheme.primary
                                                .withAlpha(28),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  LucideIcons.file,
                                                  size: 20,
                                                  color: contentTheme.primary,
                                                ),
                                                MySpacing.width(8),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    MyText.bodyMedium(
                                                      file.name,
                                                      color:
                                                          contentTheme.primary,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontWeight: 600,
                                                    ),
                                                    MyText.bodySmall(
                                                      Utils
                                                          .getStorageStringFromByte(
                                                        file.bytes?.length ?? 0,
                                                      ),
                                                      color:
                                                          contentTheme.primary,
                                                    ),
                                                  ],
                                                ),
                                                MySpacing.width(20),
                                                IconButton(
                                                  onPressed: () => controller
                                                      .removeFile(file),
                                                  icon: Icon(
                                                    LucideIcons.x,
                                                    color: contentTheme.primary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ],
                                MySpacing.height(16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const MyText.bodyMedium(
                                      "Project Priority",
                                      fontWeight: 600,
                                      muted: true,
                                    ),
                                    MySpacing.height(8),
                                    PopupMenuButton(
                                      itemBuilder: (BuildContext context) {
                                        return [
                                          "Mike",
                                          "lorene",
                                          "Beatrice",
                                          "Geneva",
                                          "Helmed",
                                        ].map((behavior) {
                                          return PopupMenuItem(
                                            value: behavior,
                                            height: 32,
                                            child: MyText.bodySmall(
                                              behavior.toString(),
                                              color: theme
                                                  .colorScheme.onSurface,
                                              fontWeight: 600,
                                            ),
                                          );
                                        }).toList();
                                      },
                                      offset: const Offset(0, 40),
                                      onSelected: controller.onSelectedSize,
                                      color: theme.cardTheme.color,
                                      child: MyContainer.bordered(
                                        paddingAll: 8,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            MyText.labelMedium(
                                              controller.selectProperties
                                                  .toString(),
                                              color: theme
                                                  .colorScheme.onSurface,
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                left: 4,
                                              ),
                                              child: Icon(
                                                LucideIcons.chevronDown,
                                                size: 22,
                                                color: theme
                                                    .colorScheme.onSurface,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      MySpacing.height(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          MyButton(
                            onPressed: () {
                              // TODO mutate firestore
                            },
                            elevation: 0,
                            padding: MySpacing.xy(20, 16),
                            backgroundColor: contentTheme.primary,
                            borderRadiusAll: AppStyle.buttonRadius.medium,
                            child: Row(
                              children: [
                                Icon(
                                  LucideIcons.checkCircle2,
                                  size: 16,
                                  color: contentTheme.light,
                                ),
                                MySpacing.width(8),
                                MyText.bodySmall(
                                  'Create',
                                  color: contentTheme.onPrimary,
                                ),
                              ],
                            ),
                          ),
                          MySpacing.width(16),
                          MyButton(
                            onPressed: () {},
                            elevation: 0,
                            padding: MySpacing.xy(20, 16),
                            backgroundColor: contentTheme.secondary,
                            borderRadiusAll: AppStyle.buttonRadius.medium,
                            child: Row(
                              children: [
                                Icon(
                                  LucideIcons.x,
                                  size: 16,
                                  color: contentTheme.light,
                                ),
                                MySpacing.width(8),
                                MyText.bodySmall(
                                  'Cancel',
                                  color: contentTheme.onSecondary,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  buildTextField(String fieldTitle, String hintText) {
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
