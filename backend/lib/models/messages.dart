import 'package:fennec_pg/fennec_pg.dart';

import 'chat.dart';

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
  @BelongsTo(
      localKey: 'chatId', foreignKey: 'chat_id', fetchType: FetchType.exclude)
  Chat? chat;

  Messages(this.from, this.to, this.content, this.timestamp);

  Messages.empty();

  Messages.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    from = map['from'];
    to = map['to'];
    content = map['content'];
    timestamp = map['timestamp'];
    if (map['chat'] != null) {
      chat = Chat.fromJson(map['chat']);
    }
  }
}
