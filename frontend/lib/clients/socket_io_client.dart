import 'package:frontend/utils/constants.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketIoClient {
  static final SocketIoClient _instance = SocketIoClient._internal();

  // passes the instantiation to the _instance object
  factory SocketIoClient() => _instance;
  late Socket _socket;

  Socket get socket => _socket;

  SocketIoClient._internal() {
    _socket = io(
        basePath,
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .enableForceNewConnection() // necessary because otherwise it would reuse old connection
            .setExtraHeaders(<String, dynamic>{})
            .setQuery({})
            .build());
    _socket.connect();

    _socket.onError((data) {
      print(data);
    });
  }
}
