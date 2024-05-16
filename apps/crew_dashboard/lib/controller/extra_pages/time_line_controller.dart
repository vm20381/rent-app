import 'package:captainapp_crew_dashboard/controller/my_controller.dart';
import 'package:captainapp_crew_dashboard/models/discover.dart';

class TimeLineController extends MyController {
  List<Discover> discover = [];

  @override
  void onInit() {
    super.onInit();
    Discover.dummyList.then((value) {
      discover = value.sublist(0, 10);
      update();
    });
  }
}
