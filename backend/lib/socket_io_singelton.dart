import 'package:fennec_socket_io_server/server_io.dart';

class SocketIOSingelton {
  static final SocketIOSingelton _singleton = SocketIOSingelton._internal();
  static SocketIOSingelton get instance => _singleton;
  late ServerIO serverIO;
  factory SocketIOSingelton(ServerIO serverIO) {
    _singleton.serverIO = serverIO;
    return _singleton;
  }

  SocketIOSingelton._internal();
}
