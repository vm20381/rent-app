import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

import 'package:luscombencut/controllers/second_circle/circle_controller.dart';
import 'package:luscombencut/views/layouts/layout.dart';

class CirclePage extends StatelessWidget {
  final CircleController controller = Get.put(CircleController());
  
  CirclePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Using MediaQuery to ensure it takes full height of the screen
    final screenHeight = MediaQuery.of(context).size.height;
    return Layout(
      child: GetBuilder<CircleController>(
        builder: (controller) {
          return Container(
            height: screenHeight,  
            child: Center(
              child: GestureDetector(
                onPanStart: (details) {
                  controller.handlePanStart(details, Offset(150, 150));  // Assuming center for simplicity
                },
                onPanUpdate: (details) {
                  controller.handlePanUpdate(details, Offset(150, 150));
                },
                onPanEnd: (details) {
                  controller.handlePanEnd();
                },
                child: Transform.rotate(
                  angle: controller.angle,
                  child: Container(
                    width: 300,
                    height: 300,
                    color: Colors.blue.withOpacity(0.3),
                    alignment: Alignment.center,
                    child: Text(
                      'Angle: ${(controller.angle * 180 / math.pi).toStringAsFixed(2)}°',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
