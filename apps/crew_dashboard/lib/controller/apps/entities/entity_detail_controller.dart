import 'package:captainapp_crew_dashboard/models/entity_item.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:captainapp_crew_dashboard/controller/my_controller.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_text_utils.dart';
import 'package:captainapp_crew_dashboard/images.dart';

class ChartData {
  ChartData({this.x, this.yValue1, this.yValue2});

  final String? x;
  final double? yValue1;
  final double? yValue2;
}

class EntityDetailController extends MyController {
  Rx<EntityItem?> entityObservable = Rx<EntityItem?>(null);

  var isLoading = true.obs;
  RxString qrCodeUrl = ''.obs;

  void fetchEntityDetails(String entityId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('entities')
          .doc(entityId)
          .get();
      entityObservable.value = EntityItem.fromFirestore(doc);

      String gsUri =
          'gs://captainapp-crew-2024.appspot.com/qrcodes/$entityId.svg';
      final ref = FirebaseStorage.instance.refFromURL(gsUri);
      qrCodeUrl.value = await ref.getDownloadURL();
      isLoading(false);
    } catch (e) {
      isLoading(false);
      if (kDebugMode) {
        print(e);
      } // Handle errors appropriately
    }
  }

  List<String> dummyTexts =
      List.generate(12, (index) => MyTextUtils.getDummyText(60));
  List<String> images = [
    Images.avatars[0],
    Images.avatars[1],
    Images.avatars[2],
    Images.avatars[3],
    Images.avatars[4],
  ];

  final List<ChartData> chartData = <ChartData>[
    ChartData(x: 'Mon', yValue1: 45, yValue2: 1000),
    ChartData(x: 'Tue', yValue1: 100, yValue2: 3000),
    ChartData(x: 'Wed', yValue1: 25, yValue2: 1000),
    ChartData(x: 'The', yValue1: 100, yValue2: 2000),
    ChartData(x: 'Fri', yValue1: 85, yValue2: 1000),
    ChartData(x: 'Sat', yValue1: 60, yValue2: 2000),
    ChartData(x: 'Sun', yValue1: 140, yValue2: 4000),
  ];

  // String getEntityQRCodeUrl(String entityId) {
  //   return "https://storage.googleapis.com/captainapp-crew-2024.appspot.com/qrcodes/$entityId.svg";
  // }

  String getEntityQRCodeUrl(String entityId) {
    return qrCodeUrl.value;
  }
}
