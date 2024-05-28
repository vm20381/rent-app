import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'dart:io' as io; // Conditional import for non-web platforms

class CircleController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  var friendsData = <Map<String, dynamic>>[].obs;
  var loading = true.obs;
  var angle = 0.0.obs;

  Offset _startOffset = Offset.zero;
  double _currentAngle = 0.0;
  double _totalRotation = 0.0;

  @override
  void onInit() {
    super.onInit();
    fetchFriendsData();
  }

  void handlePanStart(DragStartDetails details, Offset center) {
    _startOffset = details.localPosition - center;
    _currentAngle = 0.0;
  }

  void handlePanUpdate(DragUpdateDetails details, Offset center) {
    final currentOffset = details.localPosition - center;
    final startAngle = math.atan2(_startOffset.dy, _startOffset.dx);
    final currentAngle = math.atan2(currentOffset.dy, currentOffset.dx);
    _currentAngle = currentAngle + startAngle;
    angle.value = _totalRotation - _currentAngle;
  }

  void handlePanEnd() {
    _totalRotation -= _currentAngle;
    angle.value = _totalRotation;
  }

  double get getAngle => angle.value;

  Future<void> fetchFriendsData() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('friends').get();
      friendsData.value = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      print('Fetched friends data: ${friendsData.length} friends found.');
    } catch (e) {
      print('Error fetching friends data: $e');
    } finally {
      loading.value = false;
    }
  }

  Future<String> getProfilePictureUrl(String filePath) async {
    try {
      print('Fetching download URL for: $filePath');
      String downloadUrl = await _storage.ref(filePath).getDownloadURL();
      print('Download URL for $filePath: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('Error fetching download URL for $filePath: $e');
      return '';
    }
  }

  Future<void> uploadProfilePicture(XFile pickedFile) async {
    try {
      String fileName = 'profile_pictures/${DateTime.now().millisecondsSinceEpoch}.jpg';

      if (kIsWeb) {
        // Web upload
        final bytes = await pickedFile.readAsBytes();
        await _storage.ref(fileName).putData(bytes);
      } else {
        // Mobile/Desktop upload
        io.File file = io.File(pickedFile.path);
        await _storage.ref(fileName).putFile(file);
      }
      
      await _firestore.collection('friends').add({
        'name': 'New Friend',
        'profile_picture': fileName,
      });
      print('Uploaded profile picture: $fileName');
      await fetchFriendsData();
    } catch (e) {
      print('Error uploading profile picture: $e');
    }
  }
}
