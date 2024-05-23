import 'dart:math' as math;
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';

class CircleController extends GetxController {
  Offset _startOffset = Offset.zero;
  double _currentAngle = 0.0;
  double _totalRotation = 0.0;

  void handlePanStart(DragStartDetails details, Offset center) {
    _startOffset = details.localPosition - center;
    _currentAngle = 0.0;
  }

  void handlePanUpdate(DragUpdateDetails details, Offset center) {
    final currentOffset = details.localPosition - center;
    final startAngle = math.atan2(_startOffset.dy, _startOffset.dx);
    final currentAngle = math.atan2(currentOffset.dy, currentOffset.dx);
    _currentAngle = currentAngle - startAngle;
    update();  // Triggers update on GetBuilder
  }

  void handlePanEnd() {
    _totalRotation += _currentAngle;
    _currentAngle = 0.0;
    update();  // Ensure final update if needed
  }

  double get angle => _totalRotation + _currentAngle;
}
