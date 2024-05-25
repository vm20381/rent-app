import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenboi123/models/chat_model.dart';

class ChatController extends GetxController {
  final TextEditingController messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String userName = '';

  Stream<List<ChatMessage>> getMessages() {
    return _firestore.collection('chat').orderBy('timestamp').snapshots().map(
      (QuerySnapshot query) {
        List<ChatMessage> messages = [];
        for (var doc in query.docs) {
          messages.add(ChatMessage.fromFirestore(doc));
        }
        return messages;
      },
    );
  }

  Future<void> sendMessage(String message) async {
    if (message.isNotEmpty) {
      ChatMessage chatMessage = ChatMessage(
        id: '',
        userName: userName,
        message: message,
        timestamp: Timestamp.now(),
      );
      await _firestore.collection('chat').add(chatMessage.toFirestore());
      messageController.clear();
    }
  }

  void setUserName(String name) {
    userName = name;
  }
}
