import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/views/layouts/layout.dart';
import '/controllers/new_page/new_page_controller.dart';

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
              child: ElevatedButton(
                onPressed: controller.navigateToHomePage,
                child: Text('Navigate to Home Page'),
              ),
            ),
          );
        },
      ),
    );
  }
}