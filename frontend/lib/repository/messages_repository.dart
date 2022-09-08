import 'package:dio/dio.dart';
import 'package:frontend/models/message.dart';

import '../utils/constants.dart';

class MessagesRepository {
  final Dio _dio = Dio();

  Future<List<Message>> loadMessages(String chatId) async {
    List<Message> messages = [];
    print(chatId);
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
      print(e);
      return messages;
    }
  }
}
