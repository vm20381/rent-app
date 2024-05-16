import 'package:captainapp_crew_dashboard/controller/my_controller.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_text_utils.dart';

class FaqsController extends MyController {
  List<String> dummyTexts =
      List.generate(12, (index) => MyTextUtils.getDummyText(60));
}
