import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:macieeej/helpers/services/auth_services.dart';
import 'package:macieeej/helpers/services/firebase_subscription_services.dart';
import '../../models/chat.dart';

class UserChat {
  final String firstName;
  String lastSendMessage;
  DateTime lastSendAt;

  UserChat({
    required this.firstName,
    required this.lastSendMessage,
    required this.lastSendAt,
  });
}

class ChatController extends GetxController {
  var chat = <Chat>[].obs;
  var chatUsers = <UserChat>[].obs;
  final AuthService authService = Get.find<AuthService>();
  final FirestoreSubscriptionService _firestoreSubService = Get.find<FirestoreSubscriptionService>();
  final TextEditingController messageController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _subscribeToChatMessages();
  }

  void _subscribeToChatMessages() {
    _firestoreSubService.collectionStream<Chat>(
      'chat_messages',
      (data, documentId) => Chat.fromFirestore(data, documentId),
    ).listen((chatMessages) {
      // Update fromMe field
      final user = authService.user;
      if (user != null) {
        final displayName = user.displayName ?? '';
        chatMessages = chatMessages.map((message) {
          return Chat(
            id: message.id,
            firstName: message.firstName,
            message: message.message,
            sendAt: message.sendAt,
            sendMessage: message.sendMessage,
            receiveMessage: message.receiveMessage,
            fromMe: message.firstName == displayName,
          );
        }).toList();
      }

      // Sort messages from oldest to newest
      chatMessages.sort((a, b) => a.sendAt.compareTo(b.sendAt));
      chat.value = chatMessages;
      _updateChatUsers();
    });
  }

  void _updateChatUsers() {
    Map<String, UserChat> usersMap = {};

    for (var message in chat) {
      if (!usersMap.containsKey(message.firstName)) {
        usersMap[message.firstName] = UserChat(
          firstName: message.firstName,
          lastSendMessage: message.message,
          lastSendAt: message.sendAt,
        );
      } else {
        if (message.sendAt.isAfter(usersMap[message.firstName]!.lastSendAt)) {
          usersMap[message.firstName]!.lastSendMessage = message.message;
          usersMap[message.firstName]!.lastSendAt = message.sendAt;
        }
      }
    }

    chatUsers.value = usersMap.values.toList();
  }

  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty) {
      return;
    }

    final user = authService.user;
    if (user != null) {
      Chat message = Chat(
        id: '',
        firstName: user.displayName ?? 'Unknown',
        message: messageController.text.trim(),
        sendAt: DateTime.now(),
        sendMessage: messageController.text.trim(),
        receiveMessage: '',
        fromMe: true,
      );
      await FirebaseFirestore.instance.collection('chat_messages').add(message.toFirestore());
      messageController.clear();
    }
  }
}
