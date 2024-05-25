import 'package:greenboi123/controllers/my_controller.dart';
import 'package:greenboi123/models/complex_chat_model.dart';
import 'package:flutter/material.dart';

class ComplexChatController extends MyController {
  List<Chat> chat = [];

  TextEditingController messageController = TextEditingController();

  void sendMessage() {
    chat.add(
      Chat(
        (-1) as String,
        "",
        "",
        DateTime.now(),
        messageController.text,
        "",
        true,
      ),
    );
    messageController.clear();
    update();
  }

  @override
  void onInit() {
    super.onInit();
    Chat.dummyList.then((value) {
      chat = value.sublist(0, 10);
      update();
    });
  }
}
