import 'package:flutter/material.dart';
import 'package:frontend/models/message.dart';
import 'package:frontend/models/user.dart';

class Chat {
  late String chatId;
  late Message? lastMessage;
  late User firstUser;
  late User secondUser;

  Chat(this.chatId);

  Chat.fromJson(Map<String, dynamic> map) {
    print(map);
    chatId = map['chatId'];
    lastMessage = Message.fromJson(map['lastMessage']);
    firstUser = User.fromJson(map['firstUser']);
    secondUser = User.fromJson(map['secondUser']);
  }
}
