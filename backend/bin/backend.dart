import 'dart:io';

import 'package:backend/routers/auth_router.dart';
import 'package:backend/routers/chat_router.dart';
import 'package:backend/routers/messages_router.dart';
import 'package:backend/socket_io_singelton.dart';
import 'package:fennec/fennec.dart';
import 'package:fennec_pg/pg_connection_adapter.dart';
import 'package:fennec_socket_io_server/server_io.dart';

void main(List<String> arguments) async {
  var uri = 'postgres://postgres:StartAppPassword@localhost:5432/test_flutter';
  await PGConnectionAdapter.initPool(uri);
  Application application = Application();
  application.useSocketIOServer(false);
  application
      .addRouter(authRouter())
      .addRouter(chatRouter())
      .addRouter(messagesRouter());
  ServerIO serverIO = ServerIO();
  application.setPort(8000).setHost(InternetAddress.loopbackIPv4);
  Server server = Server(application);
  await server.startServer();
  SocketIOSingelton(serverIO);
  await serverIO.listenToHttpServer(server.httpServerStream);

  serverIO.on('connection', (client) {
    print('connection server');
    serverIO.emit('fromServer', 'ok123');
  });
  serverIO.on('fromServer', (e) {
    print('Server on');
  });
}
