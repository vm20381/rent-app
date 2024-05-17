import 'package:captainapp_crew_dashboard/controller/my_controller.dart';
import 'package:captainapp_crew_dashboard/helpers/utils/my_utils.dart';
import 'package:captainapp_crew_dashboard/images.dart';
import 'package:captainapp_crew_dashboard/models/entity_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
// import 'package:captainapp_crew_dashboard/helpers/widgets/my_text_utils.dart';
// import 'package:captainapp_crew_dashboard/images.dart';

// Make sure to import your newly created EntityList model here
// import 'path_to_your_entity_list_model.dart';

class EntityListController extends MyController {
  List<EntityItem> entityList = [];
  List<String> dummyTexts =
      List.generate(12, (index) => MyTextUtils.getDummyText(60));
  List<String> images = [
    Images.avatars[0],
    Images.avatars[1],
    Images.avatars[2],
    Images.avatars[3],
  ];
  @override
  void onInit() {
    super.onInit();
    loadEntities();
  }

  void loadEntities() {
    final firestore = FirebaseFirestore.instance;
    firestore.collection('entities').get().then((snapshot) {
      List<EntityItem> loadedEntities =
          snapshot.docs.map((doc) => EntityItem.fromFirestore(doc)).toList();
      entityList = loadedEntities;
      update(); // Refresh the UI with new data
    }).catchError((error) {
      // Handle errors, perhaps show an error message
    });
  }

  void goToCreateEntity() {
    Get.toNamed('/entities/create-entity');
  }

  void goToEntityDetails(EntityItem entityList) {
    Get.toNamed('/entities/${entityList.id}');
  }
}
