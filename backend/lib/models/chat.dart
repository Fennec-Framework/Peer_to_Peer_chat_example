import 'package:backend/models/user.dart';
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
      fetchType: FetchType.exclude,
      localKey: 'chat_id',
      foreignKey: 'chatId')
  List<Messages> messages = [];
  @BelongsTo(
      localKey: 'id', foreignKey: 'firstUserId', fetchType: FetchType.include)
  late User firstUser;
  @BelongsTo(
      localKey: 'id', foreignKey: 'secondUserId', fetchType: FetchType.include)
  late User secondUser;

  Chat(this.chatId);

  Chat.fromJson(Map<String, dynamic> map) {
    chatId = map['chatId'];
    lastMessage = map['lastMessage'];
    if (map['messages'] != null) {
      messages = List<Messages>.from(
          map['messages'].map((e) => Messages.fromJson(e)).toList());
    }
    if (map['firstUser'] != null) {
      firstUser = User.fromJson(map['firstUser']);
    }
    if (map['secondUser'] != null) {
      secondUser = User.fromJson(map['secondUser']);
    }
  }
}
