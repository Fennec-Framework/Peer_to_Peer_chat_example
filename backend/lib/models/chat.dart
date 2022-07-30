import 'package:fennec_pg/fennec_pg.dart';

@Table('chats')
class Chat extends Serializable {
  @PrimaryKey(columnType: ColumnType.varChar, autoIncrement: false)
  late String chatId;
  @Column(type: ColumnType.json)
  Map<String, dynamic> lastMessage = {};
  @HasMany(
      cascadeOnDelete: CascadeType.delete,
      fetchType: FetchType.exclude,
      localKey: 'id',
      foreignKey: 'chatId')
  Chat(this.chatId);
  Chat.fromJson(Map<String, dynamic> map) {
    chatId = map['chatId'];
    lastMessage = map['lastMessage'];
  }
}
