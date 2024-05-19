import '/helpers/widgets/my_spacing.dart';
// import 'package:example_package/example_package.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/controllers/home/home_page_controller.dart';
import '/views/layouts/layout.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomePageController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(HomePageController());
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: GetBuilder<HomePageController>(
        builder: (controller) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Welcome ${controller.nameOfUser} to Your App!'),
                MySpacing.height(16),
                const Text('This is the home page.'),
                MySpacing.height(30),
                const Text('Remember, read the README.md file!'),
                // note: after you add example_package to your pubspec.yaml; you'll need to rerun melos bootstrap.
                // ExamplePackageWidget(
                //   message: controller.serviceMessage,
                // ),
              ],
            ),
          );
        },
      ),
    );
  }
}
