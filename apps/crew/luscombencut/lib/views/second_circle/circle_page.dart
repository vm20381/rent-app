import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:luscombencut/controllers/second_circle/circle_controller.dart';
import 'package:luscombencut/views/layouts/layout.dart';
import 'package:image_picker/image_picker.dart';

class CirclePage extends StatelessWidget {
  final CircleController controller = Get.put(CircleController());

  CirclePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: Obx(() {
              if (controller.loading.value) {
                return Center(child: CircularProgressIndicator());
              }
              if (controller.friendsData.isEmpty) {
                return Center(child: Text('No friends found.'));
              }
              return Center(
                child: Wrap(
                  spacing: 20.0,
                  runSpacing: 20.0,
                  alignment: WrapAlignment.center,
                  children: controller.friendsData.map((friend) {
                    String name = friend['name'];
                    String profilePicturePath = friend['profile_picture'];
                    print('Rendering friend: $name, profile picture path: $profilePicturePath');
                    return FutureBuilder<String>(
                      future: controller.getProfilePictureUrl(profilePicturePath),
                      builder: (context, snapshot) {
                        print('FutureBuilder for $name, connection state: ${snapshot.connectionState}');
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          print('FutureBuilder waiting for $profilePicturePath');
                          return CircularProgressIndicator();
                        }
                        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                          print('FutureBuilder error for $profilePicturePath: ${snapshot.error}');
                          return Column(
                            children: [
                              Icon(Icons.error),
                              if (snapshot.hasError) Text('Error: ${snapshot.error}'),
                              if (!snapshot.hasData || snapshot.data!.isEmpty) Text('No URL found'),
                            ],
                          );
                        }

                        String profilePictureUrl = snapshot.data!;
                        print('Profile picture URL for $name: $profilePictureUrl');
                        return GestureDetector(
                          onTap: () {
                            // Handle tap event
                            print('Tapped on $name');
                          },
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(profilePictureUrl),
                            radius: 40.0,
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              );
            }),
          ),
          SizedBox(height: 20),

          ElevatedButton(
            onPressed: () => _selectAndUploadProfilePicture(),
            child: Text('Add Friend'),
          ),
                        SizedBox(height: 100),
          LayoutBuilder(
            builder: (context, constraints) {
              final center = Offset(
                constraints.maxWidth.isFinite ? constraints.maxWidth / 2 : 150,
                constraints.maxHeight.isFinite ? constraints.maxHeight / 2 : 150,
              );

              return GestureDetector(
                onPanStart: (details) {
                  controller.handlePanStart(details, center);
                },
                onPanUpdate: (details) {
                  controller.handlePanUpdate(details, center);
                },
                onPanEnd: (details) {
                  controller.handlePanEnd();
                },
                child: Obx(() {
                  return Transform.rotate(
                    angle: controller.getAngle,
                    child: Container(
                      width: 300,
                      height: 300,
                      color: Colors.blue.withOpacity(0.3),
                      alignment: Alignment.center,
                      child: Text(
                        'Angle: ${(controller.getAngle * 180 / math.pi).toStringAsFixed(2)}°',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _selectAndUploadProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      print('Selected file path: ${pickedFile.path}');
      await controller.uploadProfilePicture(pickedFile);
    }
  }
}
