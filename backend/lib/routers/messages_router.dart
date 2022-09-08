import 'dart:io';

import 'package:backend/models/messages.dart';
import 'package:backend/repositories/user_repository.dart';
import 'package:backend/socket_io_singelton.dart';
import 'package:fennec/fennec.dart';

import 'package:fennec_pg/fennec_pg.dart';

import '../middlewares/auth_middlware.dart';

Router messagesRouter() {
  Router router = Router(routerPath: '/api/v1/messages');
  final MessagesRepository messagesRepository = MessagesRepository();
  final ChatRepository chatRepository = ChatRepository();
  //router.useMiddleware(verfiyToken);

  router.post(
      path: '/createmessage',
      requestHandler: (req, res) async {
        String chatId = req.body['chatId'];
        var chat = await chatRepository.findOneById(chatId);
        if (chat == null) {
          return res.badRequest(
              body: {'message': 'Chat with $chatId not found'},
              contentType: ContentType.json);
        } else {
          Messages messages = Messages(req.body['from'], req.body['to'],
              req.body['content'], DateTime.now().millisecondsSinceEpoch);
          messages.chat = chat;

          final result = await messagesRepository.insert(messages);

          if (result != null) {
            Map<String, dynamic> chatMap = result.toJson();
            if (chatMap.containsKey('chat')) {
              chatMap.remove('chat');
            }
            chat.lastMessage = chatMap;
            chat = await chatRepository.updateOneById(chatId, chat);
            if (chat != null) {
              SocketIOSingelton.instance.serverIO.emit(
                  'realtime/chat/${chat.chatId}/messages',
                  {'event': 'create', 'data': result.toJson()});
              SocketIOSingelton.instance.serverIO.emit(
                  'realtime/chats', {'event': 'update', 'data': chat.toJson()});
              return res.ok(
                  body: {'res': result.toJson()},
                  contentType: ContentType.json);
            } else {
              return res.badRequest(body: 'error');
            }
          } else {
            return res.badRequest(body: 'error');
          }
        }
      });
  router.put(
      path: '/updatemessage/@messageId',
      middlewares: [],
      requestHandler: (req, res) async {
        print(req.additionalData);
        String chatId = req.body['chatId'];
        var chat = await chatRepository.findOneById(chatId);
        if (chat == null) {
          return res.badRequest(
              body: {'message': 'Chat with $chatId not found'},
              contentType: ContentType.json);
        } else {
          int messageId = int.parse(req.pathParams['messageId']);

          Messages? messages = await messagesRepository.findOneById(messageId);
          if (messages == null) {
            return res.badRequest(body: 'error');
          }
          messages.content = req.body['content'];

          final result =
              await messagesRepository.updateOneById(messageId, messages);

          if (result != null) {
            SocketIOSingelton.instance.serverIO.emit(
                'realtime/chat/${chat.chatId}/messages',
                {'event': 'update', 'data': result.toJson()});
            return res.ok(
                body: {'res': result.toJson()}, contentType: ContentType.json);
          } else {
            return res.badRequest(body: 'error');
          }
        }
      });
  router.get(
      path: '/getMessages/@chatId',
      requestHandler: (req, res) async {
        print(req.pathParams['chatId']);
        String chatId = req.pathParams['chatId'] as String;
        print('aaa');

        FilterBuilder filterBuilder =
            Equals(Field.tableColumn('chat_id'), Field.string(chatId));

        final result =
            await messagesRepository.findAll(filterBuilder: filterBuilder);

        return res.ok(body: {'result': result}, contentType: ContentType.json);
      });
  return router;
}
