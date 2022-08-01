import 'package:backend/models/messages.dart';
import 'package:backend/repositories/user_repository.dart';
import 'package:backend/socket_io_singelton.dart';
import 'package:fennec/fennec.dart';
import 'package:fennec_jwt/fennec_jwt.dart';
import 'package:fennec_pg/fennec_pg.dart';

import '../middlewares/auth_middlware.dart';
import 'auth_router.dart';

Router messagesRouter() {
  Router router = Router(routerPath: '/api/v1/messages');
  final MessagesRepository messagesRepository = MessagesRepository();
  final ChatRepository chatRepository = ChatRepository();
  router.useMiddleware(verfiyToken);

  router.post(
      path: '/createmessage',
      requestHandler: (req, res) async {
        String chatId = req.body['chatId'];
        var chat = await chatRepository.findOneById(chatId);
        if (chat == null) {
          res.badRequest().json({'message': 'Chat with $chatId not found'});
        }
        {
          Messages messages = Messages(
              req.body['from'],
              req.body['to'],
              req.body['content'],
              DateTime.now().millisecondsSinceEpoch,
              chatId);
          final result = await messagesRepository.insert(messages);

          if (result != null) {
            chat!.lastMessage = result.toJson();

            chat = await chatRepository.updateOneById(chatId, chat);
            if (chat != null) {
              SocketIOSingelton.instance.serverIO.emit(
                  'realtime/chat/${chat.chatId}/messages',
                  {'event': 'create', 'data': result.toJson()});
              SocketIOSingelton.instance.serverIO.emit(
                  'realtime/chats', {'event': 'update', 'data': chat.toJson()});
              res.json({'res': result.toJson()});
            } else {
              res.badRequest().send('error');
            }
          } else {
            res.badRequest().send('error');
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
          res.badRequest().json({'message': 'Chat with $chatId not found'});
        } else {
          int messageId = int.parse(req.pathParams['messageId']);

          Messages? messages = await messagesRepository.findOneById(messageId);
          if (messages == null) {
            res.badRequest().send('error');
            return;
          }
          messages.content = req.body['content'];

          final result =
              await messagesRepository.updateOneById(messageId, messages);

          if (result != null) {
            SocketIOSingelton.instance.serverIO.emit(
                'realtime/chat/${chat.chatId}/messages',
                {'event': 'update', 'data': result.toJson()});
            res.json({'res': result.toJson()});
          } else {
            res.badRequest().send('error');
          }
        }
      });
  router.get(
      path: '/getMessages/@chatId',
      requestHandler: (req, res) async {
        String chatId = req.pathParams['chatId'];

        SelectBuilder selectBuilder = SelectBuilder(['*']);
        selectBuilder.setLimit(10);

        selectBuilder.condition =
            Equals(Field.tableColumn('chat_id'), Field.string(chatId));

        final result = await messagesRepository.selectAll(selectBuilder);

        res.json({'res': result});
      });
  return router;
}
