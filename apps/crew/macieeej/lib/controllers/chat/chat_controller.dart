import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:macieeej/helpers/services/auth_services.dart';
import 'package:macieeej/helpers/services/firebase_subscription_services.dart';
import '../../models/chat.dart';

class UserChat {
  final String senderName;
  String lastSendMessage;
  DateTime lastSendAt;

  UserChat({
    required this.senderName,
    required this.lastSendMessage,
    required this.lastSendAt,
  });
}

class ChatController extends GetxController {
  var chat = <Chat>[].obs;
  var chatUsers = <UserChat>[].obs;
  var selectedContact = ''.obs;
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
            senderName: message.senderName,
            receiverName: message.receiverName,
            message: message.message,
            sendAt: message.sendAt,
            receiveMessage: message.receiveMessage,
            fromMe: message.senderName == displayName,
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
      if (!usersMap.containsKey(message.senderName)) {
        usersMap[message.senderName] = UserChat(
          senderName: message.senderName,
          lastSendMessage: message.message,
          lastSendAt: message.sendAt,
        );
      } else {
        if (message.sendAt.isAfter(usersMap[message.senderName]!.lastSendAt)) {
          usersMap[message.senderName]!.lastSendMessage = message.message;
          usersMap[message.senderName]!.lastSendAt = message.sendAt;
        }
      }
    }

    chatUsers.value = usersMap.values.toList();
  }

  List<Chat> get filteredChatMessages {
    final user = authService.user?.displayName ?? '';
    return chat.where((message) {
      final isCurrentUserSender = message.senderName == user && message.receiverName == selectedContact.value;
      final isCurrentUserReceiver = message.receiverName == user && message.senderName == selectedContact.value;
      return isCurrentUserSender || isCurrentUserReceiver;
    }).toList();
  }

  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty || selectedContact.value.isEmpty) {
      return;
    }

    final user = authService.user;
    if (user != null) {
      Chat message = Chat(
        id: '',
        senderName: user.displayName ?? 'Unknown',
        receiverName: selectedContact.value,
        message: messageController.text.trim(),
        sendAt: DateTime.now(),
        receiveMessage: '',
        fromMe: true,
      );
      await FirebaseFirestore.instance.collection('chat_messages').add(message.toFirestore());
      messageController.clear();
    }
  }
}
