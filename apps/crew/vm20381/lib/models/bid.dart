import 'package:cloud_firestore/cloud_firestore.dart';

//Defining the Bid class
class Bid {
  final String id;
  final String userId;
  final double bidAmount;
  final DateTime timestamp;

  //Constructor for the Bid class
  Bid({
    required this.id,
    required this.userId,
    required this.bidAmount,
    required this.timestamp,
  });

  //Factory method to convert the JSON data to a Bid object
  factory Bid.fromJson(Map<String, dynamic> json, String id) {
    return Bid(
      id: id,
      userId: json['userId'],
      bidAmount: json['bidAmount'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  //Method to convert the Bid object to JSON data
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'bidAmount': bidAmount,
      'timestamp': timestamp,
    };
  }
}
