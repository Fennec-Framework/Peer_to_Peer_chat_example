import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:frontend/models/message.dart';

import '../utils/constants.dart';

class MessagesRepository {
  final Dio _dio = Dio();

  Future<List<Message>> loadMessages(String chatId) async {
    List<Message> messages = [];

    try {
      final result =
          await _dio.get("$basePath/api/v1/messages/getMessages/$chatId",
              options: Options(headers: {
                "Accept": "application/json",
                "content-type": "application/json",
              }));

      List<Map<String, dynamic>> list = List.from(result.data['result']);
      for (var element in list) {
        messages.add(Message.fromJson(element));
      }

      return messages;
    } catch (e) {
      return messages;
    }
  }

  Future<Map<String, dynamic>?> sendMessage(
      String chatId, int from, int to, String content) async {
    final map = {
      "chatId": chatId,
      "from": from,
      "to": to,
      "content": content,
    };

    try {
      final result = await _dio.post("$basePath/api/v1/messages/createmessage",
          data: jsonEncode(map),
          options: Options(headers: {
            "Accept": "application/json",
            "content-type": "application/json",
          }));

      return result.data['res'];
    } catch (e) {
      return null;
    }
  }
}
