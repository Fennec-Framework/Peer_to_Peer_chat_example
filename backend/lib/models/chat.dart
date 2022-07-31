import 'package:fennec_pg/fennec_pg.dart';

import 'messages.dart';

@Table('chats')
class Chat extends Serializable {
  @PrimaryKey(columnType: ColumnType.varChar, autoIncrement: false)
  late String chatId;
  @Column(type: ColumnType.json)
  Map<String, dynamic> lastMessage = {};
  @HasMany(
      cascadeOnDelete: CascadeType.delete,
      fetchType: FetchType.include,
      localKey: 'chat_id',
      foreignKey: 'chatId')
  List<Messages> messages = [];
  Chat(this.chatId);
  Chat.fromJson(Map<String, dynamic> map) {
    chatId = map['chatId'];
    lastMessage = map['lastMessage'];
    if (map['messages'] != null) {
      messages = List<Messages>.from(
          map['messages'].map((e) => Messages.fromJson(e)).toList());
    }
  }
}
