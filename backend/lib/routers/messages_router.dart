import 'package:backend/models/messages.dart';
import 'package:backend/repositories/user_repository.dart';
import 'package:fennec/fennec.dart';
import 'package:fennec_pg/fennec_pg.dart';

Router messagesRouter() {
  Router router = Router(routerPath: '/api/v1/messages');
  final MessagesRepository messagesRepository = MessagesRepository();
  router.post(
      path: '/createmessage',
      requestHandler: (req, res) async {
        Messages messages = Messages(
            req.body['from'],
            req.body['to'],
            req.body['content'],
            DateTime.now().millisecondsSinceEpoch,
            req.body['chatId']);
        final result = await messagesRepository.insert(messages);
        if (result != null) {
          res.json({'res': result.toJson()});
        } else {
          res.badRequest().send('error');
        }
      });
  router.get(
      path: '/getMessages/@chatId',
      requestHandler: (req, res) async {
        String chatId = req.pathParams['chatId'];
        print(chatId);
        SelectBuilder selectBuilder = SelectBuilder(['*']);
        selectBuilder.setLimit(10);

        selectBuilder.condition =
            Equals(Field.tableColumn('chat_id'), Field.string(chatId));

        final result = await messagesRepository.selectAll(selectBuilder);

        res.json({'res': result});
      });
  return router;
}
