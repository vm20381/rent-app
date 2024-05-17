import 'package:captainapp_crew_dashboard/controller/ui/carousels_controller.dart';
import 'package:captainapp_crew_dashboard/helpers/extensions/string.dart';
import 'package:captainapp_crew_dashboard/helpers/utils/ui_mixins.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_breadcrumb.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_breadcrumb_item.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_container.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_flex.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_flex_item.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_spacing.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_text.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/responsive.dart';
import 'package:captainapp_crew_dashboard/images.dart';
import 'package:captainapp_crew_dashboard/views/layouts/layout.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';

class Carousels extends StatefulWidget {
  const Carousels({super.key});

  @override
  State<Carousels> createState() => _CarouselsState();
}

class _CarouselsState extends State<Carousels>
    with SingleTickerProviderStateMixin, UIMixin {
  late CarouselsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(CarouselsController());
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
                      "Carousel",
                      fontSize: 18,
                      fontWeight: 600,
                    ),
                    MyBreadcrumb(
                      children: [
                        MyBreadcrumbItem(name: 'UI'),
                        MyBreadcrumbItem(name: 'Carousels', active: true),
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
                      sizes: "lg-7 md-12",
                      child: MyContainer(
                        child: Column(
                          children: [
                            MyText.titleMedium(
                              'simple'.tr(),
                              fontWeight: 600,
                              letterSpacing: 0,
                            ),
                            MySpacing.height(16),
                            simpleCarousel(),
                          ],
                        ),
                      ),
                    ),
                    MyFlexItem(
                      sizes: "lg-7 md-12",
                      child: MyContainer(
                        child: Column(
                          children: [
                            MyText.titleMedium(
                              'animated'.tr(),
                              fontWeight: 600,
                              letterSpacing: 0,
                            ),
                            MySpacing.height(16),
                            animatedCarousel(),
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

  Widget indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInToLinear,
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white.withAlpha(140),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
    );
  }

  Widget simpleCarousel() {
    List<Widget> buildPageIndicatorStatic() {
      List<Widget> list = [];
      for (int i = 0; i < controller.simpleCarouselSize; i++) {
        list.add(
          i == controller.selectedSimpleCarousel
              ? indicator(true)
              : indicator(false),
        );
      }
      return list;
    }

    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        SizedBox(
          height: 300,
          child: PageView(
            pageSnapping: true,
            scrollBehavior: AppScrollBehavior(),
            physics: const ClampingScrollPhysics(),
            controller: controller.simplePageController,
            onPageChanged: controller.onChangeSimpleCarousel,
            children: <Widget>[
              Stack(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                children: [
                  Image.asset(
                    Images.landscapeImages[0],
                    fit: BoxFit.cover,
                    height: 300,
                    width: double.infinity,
                  ),
                  MyContainer.none(
                    paddingAll: 12,
                    color: contentTheme.dark.withAlpha(150),
                    height: 300,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Center(
                      child: MyText.bodySmall(
                        controller.dummyTexts[1],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        color: contentTheme.light,
                        fontWeight: 600,
                      ),
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  Image.asset(
                    Images.landscapeImages[1],
                    fit: BoxFit.cover,
                    height: 300,
                    width: double.infinity,
                  ),
                  MyContainer.none(
                    paddingAll: 12,
                    color: contentTheme.dark.withAlpha(150),
                    height: 300,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Center(
                      child: MyText.bodySmall(
                        controller.dummyTexts[2],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        color: contentTheme.light,
                        fontWeight: 600,
                      ),
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  Image.asset(
                    Images.landscapeImages[2],
                    fit: BoxFit.cover,
                    height: 300,
                    width: double.infinity,
                  ),
                  MyContainer.none(
                    paddingAll: 12,
                    color: contentTheme.dark.withAlpha(150),
                    height: 300,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Center(
                      child: MyText.bodySmall(
                        controller.dummyTexts[3],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        color: contentTheme.light,
                        fontWeight: 600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: buildPageIndicatorStatic(),
          ),
        ),
      ],
    );
  }

  Widget animatedCarousel() {
    List<Widget> buildPageIndicatorStatic() {
      List<Widget> list = [];
      for (int i = 0; i < controller.animatedCarouselSize; i++) {
        list.add(
          i == controller.selectedAnimatedCarousel
              ? indicator(true)
              : indicator(false),
        );
      }
      return list;
    }

    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        SizedBox(
          height: 300,
          child: PageView(
            pageSnapping: true,
            scrollBehavior: AppScrollBehavior(),
            physics: const ClampingScrollPhysics(),
            controller: controller.animatedPageController,
            onPageChanged: controller.onChangeAnimatedCarousel,
            children: <Widget>[
              Stack(
                children: [
                  Image.asset(
                    Images.landscapeImages[0],
                    fit: BoxFit.cover,
                    height: 300,
                    width: double.infinity,
                  ),
                  MyContainer.none(
                    paddingAll: 12,
                    color: contentTheme.dark.withAlpha(150),
                    height: 300,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Center(
                      child: MyText.bodySmall(
                        controller.dummyTexts[4],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        color: contentTheme.light,
                        fontWeight: 600,
                      ),
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  Image.asset(
                    Images.landscapeImages[1],
                    fit: BoxFit.cover,
                    height: 300,
                    width: double.infinity,
                  ),
                  MyContainer.none(
                    paddingAll: 12,
                    color: contentTheme.dark.withAlpha(150),
                    height: 300,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Center(
                      child: MyText.bodySmall(
                        controller.dummyTexts[5],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        color: contentTheme.light,
                        fontWeight: 600,
                      ),
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  Image.asset(
                    Images.landscapeImages[2],
                    fit: BoxFit.cover,
                    height: 300,
                    width: double.infinity,
                  ),
                  MyContainer.none(
                    paddingAll: 12,
                    color: contentTheme.dark.withAlpha(150),
                    height: 300,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Center(
                      child: MyText.bodySmall(
                        controller.dummyTexts[6],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        color: contentTheme.light,
                        fontWeight: 600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: buildPageIndicatorStatic(),
          ),
        ),
      ],
    );
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
