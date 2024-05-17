import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/controllers/about/about_page_controller.dart';
import '/views/layouts/layout.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  late AboutPageController controller;

  @override
  void initState() {
    super.initState();
    controller = AboutPageController();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: GetBuilder<AboutPageController>(
        init: controller,
        builder: (controller) {
          return Column(
            children: [
              const Text('About Page'),
              const Text('Testing Creating a new page'),
              ElevatedButton(
                onPressed: controller.navigateToHome,
                child: const Text('Go to Home'),
              ),
              // Observer Widget
              Obx(() {
                return Text("User's Role: ${controller.userRole.value}");
              }),
            ],
          );
        },
      ),
    );
  }
}
