import 'package:backend/models/chat.dart';
import 'package:fennec_pg/fennec_pg.dart';

@Table('messages')
class Messages {
  @PrimaryKey(autoIncrement: true)
  int? id;
  @Column()
  late int from;
  @Column(isNullable: false)
  late int to;
  @Column(isNullable: false)
  late String content;
  @Column(isNullable: false)
  late int timestamp;
  @Column(isNullable: false, alias: 'chat_id')
  late String chatId;
  Messages(this.from, this.to, this.content, this.timestamp, this.chatId);
  Messages.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    from = map['from'];
    to = map['to'];
    content = map['content'];
    timestamp = map['timestamp'];
    chatId = map['chat_id'];
  }
}
