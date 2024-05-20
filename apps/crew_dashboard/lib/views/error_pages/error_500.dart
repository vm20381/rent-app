import 'package:captainapp_crew_dashboard/controller/error_pages/error_500_controller.dart';
import 'package:captainapp_crew_dashboard/helpers/utils/ui_mixins.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_spacing.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:lucide_icons/lucide_icons.dart';

class Error500 extends StatefulWidget {
  const Error500({super.key});

  @override
  State<Error500> createState() => _Error500State();
}

class _Error500State extends State<Error500>
    with SingleTickerProviderStateMixin, UIMixin {
  late Error500Controller controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(Error500Controller());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder(
        init: controller,
        builder: (controller) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      LucideIcons.alertCircle,
                      size: 52,
                    ),
                    MySpacing.width(20),
                    const MyText.bodyMedium(
                      "Error 500",
                      fontSize: 52,
                    ),
                  ],
                ),
                const MyText.bodyMedium(
                  "Internal Server error",
                  fontSize: 24,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
