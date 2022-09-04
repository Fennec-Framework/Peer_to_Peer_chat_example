import 'package:fennec_pg/fennec_pg.dart';

@Table('messages')
class Messages extends Serializable {
  @PrimaryKey(autoIncrement: true)
  int? id;
  @Column()
  late int from;
  @Column(isNullable: false)
  late int to;
  @Column(isNullable: false)
  late String content;
  @Column(isNullable: false, type: ColumnType.bigInt)
  late int timestamp;
  late String chatId;

  Messages(this.from, this.to, this.content, this.timestamp, this.chatId);

  Messages.empty();

  Messages.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    from = map['from'];
    to = map['to'];
    content = map['content'];
    timestamp = map['timestamp'];
    chatId = map['chat_id'];
  }
}
