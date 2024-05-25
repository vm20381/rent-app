import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenboi123/controllers/new_page/new_page_controller.dart';
import 'package:greenboi123/views/layouts/layout.dart';

class NewPage extends StatefulWidget {
  const NewPage({Key? key}) : super(key: key);

  @override
  _NewPageState createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  late NewPageController controller;

  @override
  void initState() {
    super.initState();
    controller = NewPageController(); 
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: GetBuilder<NewPageController>(
        init: controller,
        builder: (controller) {
          return Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: controller.navigateToHomePage,
                    child: const Text('Navigate to Home Page'),
                  ),
                  Obx(() {
                    return Text("Role Of User: ${controller.userRole.value}");
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}