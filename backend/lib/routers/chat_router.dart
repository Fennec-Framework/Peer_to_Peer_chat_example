import 'dart:io';

import 'package:backend/middlewares/auth_middlware.dart';
import 'package:backend/models/chat.dart';
import 'package:backend/repositories/user_repository.dart';
import 'package:fennec/fennec.dart' hide UserRepository;
import 'package:fennec_pg/fennec_pg.dart';
import 'package:fennec_pg/pg_connection_adapter.dart';

import '../models/user.dart';
import '../socket_io_singelton.dart';

Router chatRouter() {
  Router router = Router(routerPath: '/api/v1/chat');
  final ChatRepository chatRepository = ChatRepository();
  final UserRepository userRepository = UserRepository();
  //router.useMiddleware(verfiyToken);
  router.get(
      path: '/getChat/@chatId',
      requestHandler: (req, res) async {
        String chatId = req.pathParams['chatId'];
        final result = await chatRepository.findOneById(chatId);
        if (result == null) {
          res.badRequest().json({'message': 'Chat with $chatId not found'});
        } else {
          res.json({'result': result});
        }
      });
  router.get(
      path: '/chats',
      requestHandler: (req, res) async {
        final result = await chatRepository.findOneById('1_2');

        res.json({'result': result});
      });

  router.post(
      path: '/createchat',
      requestHandler: (req, res) async {
        String chatId = req.body['chatId'];
        int firstUserId = int.parse(req.body['firstUserId']);
        int secondUserId = int.parse(req.body['secondUserId']);

        Map<String, dynamic> lastMessage = req.body['lastMessage'] ?? {};
        Chat chat = Chat(chatId);
        chat.lastMessage = lastMessage;

        final result = await chatRepository.findOneById(chatId);
        if (result != null) {
          SocketIOSingelton.instance.serverIO.emit(
              'realtime/chats', {'event': 'create', 'data': result.toJson()});

          res.ok().send('chat already exist');
        } else {
          final User? firstUser = await userRepository.findOneById(firstUserId);
          if (firstUser == null) {
            res
                .status(HttpStatus.badRequest)
                .send('User with id $firstUserId not Found');
            return;
          }
          final User? secondUser =
              await userRepository.findOneById(secondUserId);
          if (secondUser == null) {
            res
                .status(HttpStatus.badRequest)
                .send('User with id $secondUserId not Found');
            return;
          }
          chat.firstUser = firstUser;
          chat.secondUser = secondUser;
          chatId = "'$chatId'";
          var lastMessageIntoSql =
              "'${lastMessage.map((key, value) => MapEntry('"$key"', value))}'";
          print(lastMessageIntoSql);
          final sqlQuery =
              'insert into chats ("chatId","lastMessage","firstUser","secondUser") values ($chatId,$lastMessageIntoSql,$firstUserId,$secondUserId) returning *';

          final result =
              await PGConnectionAdapter.connection.query(sqlQuery).toList();

          if (result.isNotEmpty) {
            SocketIOSingelton.instance.serverIO.emit(
                'realtime/chats', {'event': 'create', 'data': chat.toJson()});
            res.ok().send('chat successful created');
          } else {
            res.badRequest().send('chat coudnt be created');
          }
        }
      });
  return router;
}
