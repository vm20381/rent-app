import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:captainapp_crew_dashboard/controller/apps/entities/entity_list_controller.dart';
import 'package:captainapp_crew_dashboard/helpers/theme/app_style.dart';
import 'package:captainapp_crew_dashboard/helpers/theme/app_theme.dart';
import 'package:captainapp_crew_dashboard/helpers/utils/my_shadow.dart';
import 'package:captainapp_crew_dashboard/helpers/utils/ui_mixins.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_breadcrumb.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_breadcrumb_item.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_button.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_card.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_container.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_list_extension.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_progress_bar.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_spacing.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_text.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/responsive.dart';
import 'package:captainapp_crew_dashboard/views/layouts/layout.dart';

class EntityListPage extends StatefulWidget {
  const EntityListPage({Key? key}) : super(key: key);

  @override
  State<EntityListPage> createState() => _EntityListPageState();
}

class _EntityListPageState extends State<EntityListPage>
    with SingleTickerProviderStateMixin, UIMixin {
  late EntityListController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(EntityListController());
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: GetBuilder(
        init: controller,
        builder: (controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: MySpacing.x(flexSpacing),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText.titleMedium(
                      "Entity List",
                      fontSize: 18,
                      fontWeight: 600,
                    ),
                    MyBreadcrumb(
                      children: [
                        MyBreadcrumbItem(name: 'entities'),
                        MyBreadcrumbItem(name: 'Entity List', active: true),
                      ],
                    ),
                  ],
                ),
              ),
              MySpacing.height(flexSpacing),
              Padding(
                padding: MySpacing.x(flexSpacing),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyButton(
                      onPressed: controller.goToCreateEntity,
                      elevation: 0,
                      padding: MySpacing.xy(12, 18),
                      backgroundColor: contentTheme.primary,
                      borderRadiusAll: AppStyle.buttonRadius.medium,
                      child: MyText.bodySmall(
                        "Create Asset",
                        color: contentTheme.onPrimary,
                      ),
                    ),
                    MySpacing.height(20),
                    GridView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: controller.entityList.length,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 500,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        mainAxisExtent: 330,
                      ),
                      itemBuilder: (context, index) {
                        return MyCard(
                          onTap: () => controller.goToEntityDetails(
                            controller.entityList[index],
                          ),
                          shadow: MyShadow(elevation: 0.5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  MyText.bodyMedium(
                                    controller.entityList[index].name,
                                    fontSize: 16,
                                    fontWeight: 600,
                                  ),
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
                                          child: MyText.bodySmall("Edit"),
                                        ),
                                        PopupMenuItem(
                                          padding: MySpacing.xy(16, 8),
                                          height: 10,
                                          child: MyText.bodySmall("Delete"),
                                        ),
                                        PopupMenuItem(
                                          padding: MySpacing.xy(16, 8),
                                          height: 10,
                                          child: MyText.bodySmall("Add Member"),
                                        ),
                                        PopupMenuItem(
                                          padding: MySpacing.xy(16, 8),
                                          height: 10,
                                          child: MyText.bodySmall(
                                            "Add Due Date",
                                          ),
                                        ),
                                      ],
                                      child: const Icon(
                                        LucideIcons.moreHorizontal,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  MyContainer.rounded(
                                    color: contentTheme.primary.withAlpha(30),
                                    paddingAll: 2,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: Icon(
                                      LucideIcons.user,
                                      size: 16,
                                      color: contentTheme.primary,
                                    ),
                                  ),
                                  MySpacing.width(12),
                                  MyText.bodyMedium("PWC"),
                                ],
                              ),
                              MyContainer(
                                paddingAll: 0,
                                borderRadiusAll: 12,
                                color: contentTheme.primary.withAlpha(30),
                                child: Padding(
                                  padding: MySpacing.xy(8, 2),
                                  child: MyText.bodyMedium(
                                    "Complete",
                                    fontSize: 12,
                                    fontWeight: 600,
                                    color: contentTheme.primary,
                                  ),
                                ),
                              ),
                              MyText.bodyMedium(
                                controller.entityList[index].description,
                                maxLines: 2,
                                fontSize: 12,
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    LucideIcons.clipboardCheck,
                                    size: 20,
                                  ),
                                  MySpacing.width(8),
                                  MyText.bodyMedium(
                                    controller
                                        .entityList[index].billOfMaterials,
                                  ),
                                  MySpacing.width(12),
                                  const Icon(
                                    LucideIcons.messageSquare,
                                    size: 20,
                                  ),
                                  MySpacing.width(8),
                                  MyText.bodyMedium(
                                    controller.entityList[index].category,
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 200,
                                height: 45,
                                child: Stack(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  alignment: Alignment.centerRight,
                                  children: controller.images
                                      .mapIndexed(
                                        (index, image) => Positioned(
                                          left: (18 + (20 * index)).toDouble(),
                                          child: MyContainer.rounded(
                                            paddingAll: 2,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Image.asset(
                                                image,
                                                height: 32,
                                                width: 32,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MyText.bodyMedium(
                                    "Task Complete",
                                  ),
                                  MySpacing.height(12),
                                  MyProgressBar(
                                    width: 500,
                                    progress: controller
                                        .entityList[index].taskComplete,
                                    height: 3,
                                    radius: 4,
                                    inactiveColor: theme.dividerColor,
                                    activeColor: theme.colorScheme.primary,
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
}
