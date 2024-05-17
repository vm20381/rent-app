import 'package:captainapp_crew_dashboard/controller/my_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapPageController extends MyController {
  GoogleMapController? mapController;

  GoogleMapPageController();

  final LatLng center = const LatLng(45.521563, -122.677433);

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
}
