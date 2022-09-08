class Message {
  int? id;

  late int from;
  late int to;
  late String content;
  late int timestamp;

  Message();

  Message.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    from = map['from'];
    to = map['to'];
    content = map['content'];
    timestamp = map['timestamp'];
  }
}
