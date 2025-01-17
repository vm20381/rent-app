import 'dart:async';

import 'package:captainapp_crew_dashboard/controller/my_controller.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_text_utils.dart';
import 'package:flutter/material.dart';

class CarouselsController extends MyController {
  List<String> dummyTexts =
      List.generate(12, (index) => MyTextUtils.getDummyText(60));

  int simpleCarouselSize = 3, animatedCarouselSize = 3;
  int selectedSimpleCarousel = 0, selectedAnimatedCarousel = 0;

  Timer? timerAnimation;

  final PageController simplePageController = PageController(initialPage: 0);
  final PageController animatedPageController = PageController(initialPage: 0);

  CarouselsController();

  @override
  void onInit() {
    super.onInit();
    timerAnimation = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (selectedAnimatedCarousel < animatedCarouselSize - 1) {
        selectedAnimatedCarousel++;
      } else {
        selectedAnimatedCarousel = 0;
      }

      animatedPageController.animateToPage(
        selectedAnimatedCarousel,
        duration: const Duration(milliseconds: 600),
        curve: Curves.ease,
      );
      update();
    });
  }

  void onChangeSimpleCarousel(int value) {
    selectedSimpleCarousel = value;
    update();
  }

  void onChangeAnimatedCarousel(int value) {
    selectedAnimatedCarousel = value;
    update();
  }

  @override
  void dispose() {
    super.dispose();
    timerAnimation?.cancel();
    simplePageController.dispose();
    animatedPageController.dispose();
  }
}
