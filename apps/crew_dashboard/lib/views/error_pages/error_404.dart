import 'package:captainapp_crew_dashboard/controller/error_pages/error_404_controller.dart';
import 'package:captainapp_crew_dashboard/helpers/utils/ui_mixins.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_spacing.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:lucide_icons/lucide_icons.dart';

class Error404 extends StatefulWidget {
  const Error404({super.key});

  @override
  State<Error404> createState() => _Error404State();
}

class _Error404State extends State<Error404>
    with SingleTickerProviderStateMixin, UIMixin {
  late Error404Controller controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(Error404Controller());
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
                      "Error 404",
                      fontSize: 52,
                    ),
                  ],
                ),
                const MyText.bodyMedium(
                  "Something went wrong or the page doesn't exist anymore",
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
