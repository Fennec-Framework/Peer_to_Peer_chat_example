import 'package:flutter/material.dart';
import 'package:frontend/models/message.dart';
import 'package:frontend/models/user.dart';

class Chat {
  late String chatId;
  Message? lastMessage;
  late User firstUser;
  late User secondUser;

  Chat(this.chatId);

  Chat.fromJson(Map<String, dynamic> map) {
    chatId = map['chatId'];
    if (map['lastMessage'] != null && Map.from(map['lastMessage']).isNotEmpty) {
      lastMessage = Message.fromJson(map['lastMessage']);
    }
    firstUser = User.fromJson(map['firstUser']);
    secondUser = User.fromJson(map['secondUser']);
  }
}
