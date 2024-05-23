import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/auction_item.dart';

//Controller for the auction_item_detail_page.dart
//Controller handles bidding logic

class AuctionItemDetailController extends GetxController {
  final AuctionItem item;
  final bidController = TextEditingController();
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  AuctionItemDetailController(this.item);

  void placeBid() async {
    if (bidController.text.isEmpty) {
      errorMessage('Please enter a bid amount.');
      return;
    }

    double bidAmount = double.parse(bidController.text);
    if (bidAmount <= item.currentBid) {
      errorMessage('Your bid must be higher than the current bid.');
      return;
    }

    isLoading(true);
    try {
      await FirebaseFirestore.instance.collection('auction_items').doc(item.id).update({
        'currentBid': bidAmount,
      });
      Get.back();
    } catch (e) {
      errorMessage('Failed to place bid. Please try again.');
    } finally {
      isLoading(false);
    }
  }
}
