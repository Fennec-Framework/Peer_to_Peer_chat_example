import 'package:dio/dio.dart';
import 'package:frontend/utils/constants.dart';
import 'package:hive/hive.dart';

import '../models/chat.dart';

class ChatRepository {
  final Dio _dio = Dio();
  final Box box = Hive.box("SecureBox");

  Future<List<Chat>> loadChats(int userId) async {
    List<Chat> chats = [];
    try {
      final result = await _dio.get("$basePath/api/v1/chat/mychats/$userId",
          options: Options(headers: {
            "Accept": "application/json",
            "content-type": "application/json",
          }));

      List<Map<String, dynamic>> list = List.from(result.data['result']);
      for (var element in list) {
        chats.add(Chat.fromJson(element));
      }

      return chats;
    } catch (e) {
      return chats;
    }
  }
}
