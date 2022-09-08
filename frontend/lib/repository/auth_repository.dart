import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/utils/constants.dart';
import 'package:hive/hive.dart';

import '../models/user.dart';
import '../utils/utils.dart';

class AuthRepository {
  final Dio _dio = Dio();
  final Box box = Hive.box("SecureBox");

  Future<User?> signUp(BuildContext context, String username, String email,
      String password) async {
    try {
      final map = {'username': username, 'email': email, 'password': password};
      final result = await _dio.post(
        '$basePath/api/v1/auth/signup',
        data: jsonEncode(map),
        options: Options(headers: {
          "Accept": "application/json",
          "content-type": "application/json",
        }),
      );
      if (result.statusCode == 200) {
        await box.put('currentUser', result.data);
        User user = User.fromJson(result.data['user']);
        user.token = result.data['token'];
        return user;
      } else {
        // ignore: use_build_context_synchronously
        Utils.showSnackBar(context, 'this user coudln\'t SignUp',
            icon: const Icon(Icons.error), color: Colors.red);
        return null;
      }
    } on DioError catch (e) {
      Utils.showSnackBar(context, e.response.toString(),
          icon: const Icon(Icons.error), color: Colors.red);
      return null;
    } catch (e) {
      Utils.showSnackBar(context, e.toString(),
          icon: const Icon(Icons.error), color: Colors.red);
      return null;
    }
  }

  Future<User?> signIn(
      BuildContext context, String username, String password) async {
    try {
      final map = {'username': username, 'password': password};
      final result = await _dio.post(
        '$basePath/api/v1/auth/signin',
        data: jsonEncode(map),
        options: Options(headers: {
          "Accept": "application/json",
          "content-type": "application/json",
        }),
      );
      if (result.statusCode == 200) {
        await box.put('currentUser', result.data);

        User user = User.fromJson(result.data['user']);
        user.token = result.data['token'];
        return user;
      } else {
        // ignore: use_build_context_synchronously
        Utils.showSnackBar(context, 'this user coudln\'t SignIn',
            icon: const Icon(Icons.error), color: Colors.red);
        return null;
      }
    } on DioError catch (e) {
      Utils.showSnackBar(context, e.response.toString(),
          icon: const Icon(Icons.error), color: Colors.red);
      return null;
    } catch (e) {
      Utils.showSnackBar(context, e.toString(),
          icon: const Icon(Icons.error), color: Colors.red);
      return null;
    }
  }
}
