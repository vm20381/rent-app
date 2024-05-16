import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/controllers/about/about_page_controller.dart';
import '/views/layouts/layout.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  late AboutPageController controller;


  @override
  void initState() {
    super.initState();
    controller = Get.put(AboutPageController());
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: GetBuilder<AboutPageController>(
        builder: (controller) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('About Page'),
                const SizedBox(height: 16),
                const Text('This is my about page.'),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: controller.navigateToNewPage,
                  child: const Text('Go to Home Page'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}