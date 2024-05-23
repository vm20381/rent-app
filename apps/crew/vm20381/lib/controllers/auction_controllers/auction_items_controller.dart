import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/auction_item.dart';

//controller for the auction_items_page.dart

class AuctionItemsController extends GetxController {
  var auctionItems = <AuctionItem>[].obs;
  var isLoading = true.obs;

  void fetchAuctionItems() async { //Method to fetch auction items from Firestore
  try{  
    auctionItems.value = [
      AuctionItem(
        id: '1',
        description: 'Test Item 1',
        startingBid: 10.0,
        currentBid: 15.0,
        imageUrls: [],
        endTime: DateTime.now().add(Duration(hours: 1)),
      ),
      AuctionItem(
        id: '2',
        description: 'Test Item 2',
        startingBid: 20.0,
        currentBid: 25.0,
        imageUrls: [],
        endTime: DateTime.now().add(Duration(hours: 2)),
      ),
    ];


    /*
    isLoading(true);
    try {       //Try to fetch auction items from Firestore, and store them in the auctionItems list
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('auction_items').get(); //Get the auction items collection from Firestore
      auctionItems.value = snapshot.docs
          .map((doc) => AuctionItem.fromJson(doc.data() as Map<String, dynamic>, doc.id)) //Convert the JSON data to an AuctionItem object
          .toList();
    */

      
      print("Auction items fetched successfully");
      print("Fetched items: ${auctionItems.length}");
    } catch (e) {
      print("Error fetching auction items: $e");
      Get.snackbar('Error', 'Failed to fetch auction items.');  //Display an error message if fetching fails
    } finally {
      isLoading(false);
      print("Loading state: ${isLoading.value}");
    }
  }
}
