import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  String id;
  String userName;
  String message;
  Timestamp timestamp;

  ChatMessage({
    required this.id,
    required this.userName,
    required this.message,
    required this.timestamp,
  });

  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ChatMessage(
      id: doc.id,
      userName: data['userName'] ?? '',
      message: data['message'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userName': userName,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
