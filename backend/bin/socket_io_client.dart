import 'package:socket_io_client/socket_io_client.dart';

void main(List<String> arguments) async {
  Socket socket = io(
      'http://localhost:8000',
      OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Dart VM
          .enableForceNewConnection() // necessary because otherwise it would reuse old connection
          .setExtraHeaders(<String, dynamic>{})
          .build());
  socket.connect();
  socket.onConnect((data) {
    print(data);
  });
  socket.onError((data) {
    print('error');
    print(data);
  });
  Stopwatch stopwatch = Stopwatch()..start();
  socket.on('fromServer', (data) {
    print(data);
    // _socket.emit('fromServer', data);
  });

  print('backend executed in ${stopwatch.elapsed.inMilliseconds}');
}
