import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:frontend/utils/constants.dart';
import 'package:hive/hive.dart';

import '../models/chat.dart';
import '../models/user.dart';

class ChatRepository {
  final Dio _dio = Dio();
  final Box box = Hive.box("SecureBox");

  Future<String?> createChat(String chatId, int id1, int id2) async {
    Map body = {"chatId": chatId, "firstUserId": id1, "secondUserId": id2};

    try {
      final result = await _dio.post("$basePath/api/v1/chat/createchat",
          data: jsonEncode(body),
          options: Options(headers: {
            "Accept": "application/json",
            "content-type": "application/json",
          }));

      return result.data;
    } catch (e) {
      return null;
    }
  }

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

  Future<List<User>> getUsers(int userId) async {
    List<User> users = [];
    try {
      final result = await _dio.get("$basePath/api/v1/user/getUsers/$userId",
          options: Options(headers: {
            "Accept": "application/json",
            "content-type": "application/json",
          }));

      List<Map<String, dynamic>> list = List.from(result.data['result']);
      for (var element in list) {
        users.add(User.fromJson(element));
      }

      return users;
    } catch (e) {
      return users;
    }
  }
}
