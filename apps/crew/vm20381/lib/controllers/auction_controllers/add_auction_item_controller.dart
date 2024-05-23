import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';

// Controller for adding an auction item
class AddAuctionItemController extends GetxController {
  final descriptionController = TextEditingController();  //Controller for the description of the item
  final startingBidController = TextEditingController();  //Controller for the starting bid of the item, 
  List<Uint8List>? images;
  

  // Method to pick images, called when the user taps on the add images button
  Future<void> pickImages() async {
    final List<Uint8List>? pickedFiles = await ImagePickerWeb.getMultiImagesAsBytes();
    if (pickedFiles != null) {
      images = pickedFiles;
    }
    update(); // Updates the UI
  }

  // Method to upload the item to Firestore, called when the user taps on the upload button
  Future<void> uploadItem() async {
    if (descriptionController.text.isNotEmpty &&
        startingBidController.text.isNotEmpty && // Checks if the description and starting bid are not empty
        images != null) {                         //Checks if images are selected, if not, the user is prompted to select images
      List<String> imageUrls = [];
      for (var image in images!) {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();; // Generates a unique file name for the image
        Reference storageRef = FirebaseStorage.instance.ref().child('auction_items/$fileName'); // Reference to the image in Firebase Storage
        UploadTask uploadTask = storageRef.putData(image);    // Uploads the image to Firebase Storage, 
        await uploadTask.whenComplete(() async{   // Waits for the upload to complete
          String downloadUrl = await storageRef.getDownloadURL();
          imageUrls.add(downloadUrl);
        });
      }

      // Add the item to Firestore, with the image URLs,  starting bid, current bid, description and end time
      await FirebaseFirestore.instance.collection('auction_items').add({
        'description': descriptionController.text,
        'startingBid': double.parse(startingBidController.text),
        'imageUrls': imageUrls,
        'currentBid': double.parse(startingBidController.text), 
        'endTime': DateTime.now().add(Duration(hours: 1)), 
      });

      // Go back to the previous screen
      Get.back();
    }
  }
}
