import 'package:get/get.dart';

class CircleController extends GetxController {
    var counter = 0;

  void increment() {
    counter++;
    update(); // This updates the GetBuilder
  }
}