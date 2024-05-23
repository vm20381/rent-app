import 'package:cloud_firestore/cloud_firestore.dart';


//Defining the AuctionItem class

class AuctionItem {
  final String id;
  final String description;
  final double startingBid;
  final double currentBid;
  final List<String> imageUrls;
  final DateTime endTime;

  //Constructor for the AuctionItem class
  AuctionItem({
    required this.id,
    required this.description,
    required this.startingBid,
    required this.currentBid,
    required this.imageUrls,
    required this.endTime,
  });

  //Factory method to convert the JSON data to an AuctionItem object
  factory AuctionItem.fromJson(Map<String, dynamic> json, String id) {
    return AuctionItem(
      id: id,
      description: json['description'],
      startingBid: json['startingBid'],
      currentBid: json['currentBid'],
      imageUrls: List<String>.from(json['imageUrls']),
      endTime: (json['endTime'] as Timestamp).toDate(),
    );
  }

  //Method to convert the AuctionItem object to JSON data
  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'startingBid': startingBid,
      'currentBid': currentBid,
      'imageUrls': imageUrls,
      'endTime': endTime,
    };
  }
}
