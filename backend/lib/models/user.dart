import 'package:fennec_pg/fennec_pg.dart';

import 'chat.dart';

@Table('users')
class User extends Serializable {
  @PrimaryKey(autoIncrement: true)
  int? id;
  @Column(indexType: IndexType.unique, length: 30)
  String? username;
  @Column(indexType: IndexType.unique, length: 30)
  String? email;
  @Column()
  String? password;
  @Column(alias: 'is_anonym')
  bool isAnonym = false;
  @HasMany(
      localKey: 'firstUserId', foreignKey: 'id', fetchType: FetchType.exclude)
  List<Chat> firstUser = [];
  @HasMany(
      localKey: 'secondUserId', foreignKey: 'id', fetchType: FetchType.exclude)
  List<Chat> secondUser = [];

  User();

  User.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    username = map['username'];
    email = map['email'];
    password = map['password'];
    isAnonym = map['is_anonym'] ?? false;
  }
}
