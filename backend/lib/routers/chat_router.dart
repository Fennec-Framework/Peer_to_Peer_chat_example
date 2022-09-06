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
          return res.badRequest(
              body: {'message': 'Chat with $chatId not found'},
              contentType: ContentType.json);
        } else {
          return res
              .ok(body: {'result': result}, contentType: ContentType.json);
        }
      });
  router.delete(
      path: '/deletechat/@chatId',
      requestHandler: (req, res) async {
        String chatId = req.pathParams['chatId'];
        final result = await chatRepository.deleteOneById(chatId);
        if (result == null) {
          return res.badRequest(
              body: {'message': 'Chat with $chatId not found'},
              contentType: ContentType.json);
        } else {
          SocketIOSingelton.instance.serverIO.emit(
              'realtime/chats', {'event': 'delete', 'data': result.toJson()});
          return res
              .ok(body: {'result': result}, contentType: ContentType.json);
        }
      });
  router.get(
      path: '/chats',
      requestHandler: (req, res) async {
        final result = await chatRepository.findAll();

        return res.ok(body: {'result': result}, contentType: ContentType.json);
      });
  router.get(
      path: '/mychats/@userid',
      requestHandler: (req, res) async {
        int userid = int.parse(req.pathParams['userid']);
        FilterBuilder filterBuilder =
            Equals(Field.tableColumn('"firstUserId"'), Field.int(userid));
        filterBuilder
            .or(Equals(Field.tableColumn('"secondUserId"'), Field.int(userid)));
        final result =
            await chatRepository.findAll(filterBuilder: filterBuilder);

        return res.ok(body: {'result': result}, contentType: ContentType.json);
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

          return res.ok(body: 'chat already exist');
        } else {
          final User? firstUser = await userRepository.findOneById(firstUserId);
          if (firstUser == null) {
            return res.badRequest(body: 'User with id $firstUserId not Found');
          }
          final User? secondUser =
              await userRepository.findOneById(secondUserId);
          if (secondUser == null) {
            return res.badRequest(body: 'User with id $secondUserId not Found');
          }
          chat.firstUser = firstUser;
          chat.secondUser = secondUser;

          final result = await chatRepository.insert(chat);

          if (result != null) {
            SocketIOSingelton.instance.serverIO.emit(
                'realtime/chats', {'event': 'create', 'data': chat.toJson()});
            return res.ok(body: 'chat successful created');
          } else {
            return res.badRequest(body: 'chat could’nt be created');
          }
        }
      });
  return router;
}
