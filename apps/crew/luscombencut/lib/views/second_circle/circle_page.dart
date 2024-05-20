import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/second_circle/circle_controller.dart';
import '../layouts/layout.dart';

class CirclePage extends StatefulWidget {
  const CirclePage({Key? key}) : super(key: key);

  @override
  _CirclePageState createState() => _CirclePageState();
}

class _CirclePageState extends State<CirclePage> {
  late CircleController controller;

  @override
  void initState() {
    super.initState();
    controller = CircleController();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: GetBuilder<CircleController>(
        init: controller,
        builder: (controller) {
          return Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Current Count: ${controller.counter}',
                  style: TextStyle(fontSize: 24.0),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: controller.increment,
                  child: Text('Increment'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

