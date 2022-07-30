import 'package:socket_io_client/socket_io_client.dart';

void main(List<String> arguments) async {
  Socket _socket = io(
      'http://localhost:8000',
      OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Dart VM
          .enableForceNewConnection() // necessary because otherwise it would reuse old connection
          .setExtraHeaders(<String, dynamic>{})
          .build());
  _socket.connect();
  _socket.onConnect((data) {
    print(data);
  });
  _socket.onError((data) {
    print('error');
    print(data);
  });
  Stopwatch stopwatch = Stopwatch()..start();
  _socket.on('fromServer', (data) {
    print(data);
    // _socket.emit('fromServer', data);
  });

  print('backend executed in ${stopwatch.elapsed.inMilliseconds}');
}
