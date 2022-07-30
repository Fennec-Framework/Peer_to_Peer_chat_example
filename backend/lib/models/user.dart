import 'package:fennec_pg/fennec_pg.dart';

@Table('users')
class User extends Serializable {
  @PrimaryKey(autoIncrement: true)
  int? id;
  @Column(indexType: IndexType.unique, length: 30)
  String? username;
  @Column()
  String? password;
  @Column(alias: 'is_anonym')
  bool isAnonym = false;
  User();
  User.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    username = map['username'];
    password = map['password'];
    isAnonym = map['is_anonym'];
  }
}
