import 'dart:convert';
import 'package:macieeej/helpers/services/json_decoder.dart';
import 'package:macieeej/models/identifier_model.dart';
import 'package:flutter/services.dart';

class Chat {
  final String id, firstName, message, sendMessage, receiveMessage;
  final DateTime sendAt;
  final bool fromMe;

  Chat({
    required this.id,
    required this.firstName,
    required this.message,
    required this.sendAt,
    required this.sendMessage,
    required this.receiveMessage,
    required this.fromMe,
  });

  factory Chat.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Chat(
      id: documentId,
      firstName: data['first_name'] ?? '',
      message: data['message'] ?? '',
      sendAt: DateTime.parse(data['send_at']),
      sendMessage: data['send_message'] ?? '',
      receiveMessage: data['receive_message'] ?? '',
      fromMe: data['from_me'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'first_name': firstName,
      'message': message,
      'send_at': sendAt.toIso8601String(),
      'send_message': sendMessage,
      'receive_message': receiveMessage,
      'from_me': fromMe,
    };
  }

  static Chat fromJSON(Map<String, dynamic> json) {
    JSONDecoder decoder = JSONDecoder(json);

    String firstName = decoder.getString('first_name');
    String message = decoder.getString('message');
    DateTime sendAt = decoder.getDateTime('send_at');
    String sendMessage = decoder.getString('send_message');
    String receiveMessage = decoder.getString('receive_message');
    bool fromMe = decoder.getBool('from_me');

    return Chat(
      id: decoder.getId,
      firstName: firstName,
      message: message,
      sendAt: sendAt,
      sendMessage: sendMessage,
      receiveMessage: receiveMessage,
      fromMe: fromMe,
    );
  }

  static List<Chat> listFromJSON(List<dynamic> list) {
    return list.map((e) => Chat.fromJSON(e)).toList();
  }

  static List<Chat>? _dummyList;

  static Future<List<Chat>> get dummyList async {
    if (_dummyList == null) {
      dynamic data = json.decode(await getData());
      _dummyList = listFromJSON(data);
    }

    return _dummyList!.sublist(0, 10);
  }

  static Future<String> getData() async {
    return await rootBundle.loadString('assets/datas/chat_data.json');
  }
}
