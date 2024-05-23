import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/auction_item.dart';

//controller for the auction_items_page.dart

class AuctionItemsController extends GetxController {
  var auctionItems = <AuctionItem>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    listenToAuctionItems(); // Fetch items when the controller is initialized
  }
  
  /* Dummy Data for Testing purposes
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
  */
  
  void listenToAuctionItems() {
    FirebaseFirestore.instance.collection('auction_items').snapshots().listen((snapshot) {
      auctionItems.value = snapshot.docs          //Get the documents from the collection, and convert them to AuctionItem objects
          .map((doc) => AuctionItem.fromJson(doc.data() as Map<String, dynamic>, doc.id)) //Convert the JSON data to an AuctionItem object
          .toList();      //Convert the documents to a list of AuctionItem objects
      isLoading(false);   //Set the loading state to false when data is fetched
      print("Auction items fetched successfully");
      print("Fetched items: ${auctionItems.length}");
    }, onError: (e) {
      print("Error listening to auction items: $e");
      Get.snackbar('Error', 'Failed to fetch auction items.');  //Display an error message if fetching fails
    });
  }
}
