import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:macieeej/helpers/services/auth_services.dart';
import 'package:macieeej/helpers/services/firebase_subscription_services.dart';
import 'package:macieeej/models/chat_user.dart';
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
  final TextEditingController newContactController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _subscribeToChatMessages();
    _initializeChatUsers();
  }

  void _initializeChatUsers() async {
    final user = authService.user?.displayName ?? '';
    final userList = await FirebaseFirestore.instance.collection('users').get();
    final users = userList.docs
        .map((doc) => UserModel.fromFirestore(doc.data()))
        .where((userModel) => userModel.username != user)
        .toList();

    final Map<String, UserChat> usersMap = {};
    for (var userModel in users) {
      usersMap[userModel.username] = UserChat(
        senderName: userModel.username,
        lastSendMessage: '',
        lastSendAt: DateTime.now(),
      );
    }

    chatUsers.value = usersMap.values.toList();
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

  Future<void> addNewContact() async {
    final username = newContactController.text.trim();
    if (username.isEmpty) return;

    final userDoc = await FirebaseFirestore.instance.collection('users').where('username', isEqualTo: username).get();
    if (userDoc.docs.isEmpty) {
      await FirebaseFirestore.instance.collection('users').add({'username': username});
    }
    _initializeChatUsers();
  }

  void _updateChatUsers() {
    final user = authService.user?.displayName ?? '';
    Map<String, UserChat> usersMap = {};

    for (var message in chat) {
      if (message.senderName != user && message.receiverName != user) {
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
      } else if (message.receiverName != user) {
        if (!usersMap.containsKey(message.receiverName)) {
          usersMap[message.receiverName] = UserChat(
            senderName: message.receiverName,
            lastSendMessage: message.message,
            lastSendAt: message.sendAt,
          );
        } else {
          if (message.sendAt.isAfter(usersMap[message.receiverName]!.lastSendAt)) {
            usersMap[message.receiverName]!.lastSendMessage = message.message;
            usersMap[message.receiverName]!.lastSendAt = message.sendAt;
          }
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
