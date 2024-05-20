import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '/controllers/canopy/canopy_page_controller.dart';


class CanopyPage extends StatefulWidget {
  const CanopyPage({super.key});

  @override
  _CanopyPageState createState() => _CanopyPageState();
}


class _CanopyPageState extends State<CanopyPage> {
  late CanopyPageController controller;

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: Container(
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(51.509364, -0.128928),
                  zoom: 3.2,
                ),
                children: [
                  TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}