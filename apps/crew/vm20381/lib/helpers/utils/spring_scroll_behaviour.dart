
import 'package:flutter/material.dart';

class SpringScrollBehavior extends ScrollBehavior {
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return BouncingScrollPhysics(
        parent: const AlwaysScrollableScrollPhysics(),
        decelerationRate: ScrollDecelerationRate.values[1]);
  }
}