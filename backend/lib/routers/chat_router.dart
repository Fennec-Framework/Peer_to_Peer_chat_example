import 'package:backend/middlewares/auth_middlware.dart';
import 'package:backend/models/chat.dart';
import 'package:backend/repositories/user_repository.dart';
import 'package:fennec/fennec.dart';

import '../socket_io_singelton.dart';

Router chatRouter() {
  Router router = Router(routerPath: '/api/v1/chat');
  final ChatRepository chatRepository = ChatRepository();
  router.useMiddleware(verfiyToken);
  router.post(
      path: '/getChat',
      requestHandler: (req, res) async {
        String chatId = req.body['chatId'];

        final result = await chatRepository.findOneById(chatId);
        if (result == null) {
          res.badRequest().json({'message': 'Chat with $chatId not found'});
        } else {
          res.json({'result': result});
        }
      });

  router.post(
      path: '/createchat',
      requestHandler: (req, res) async {
        String chatId = req.body['chatId'];
        Map<String, dynamic> lastMessage = req.body['lastMessage'] ?? {};
        Chat chat = Chat(chatId);
        chat.lastMessage = lastMessage;
        final result = await chatRepository.findOneById(chatId);
        if (result != null) {
          SocketIOSingelton.instance.serverIO.emit(
              'realtime/chats', {'event': 'create', 'data': result.toJson()});

          res.ok().send('chat already exist');
        } else {
          final result = await chatRepository.insert(chat);
          if (result != null) {
            SocketIOSingelton.instance.serverIO.emit(
                'realtime/chats', {'event': 'create', 'data': result.toJson()});
            res.ok().send('chat successful created');
          } else {
            res.badRequest().send('chat coudnt be created');
          }
        }
      });
  return router;
}
