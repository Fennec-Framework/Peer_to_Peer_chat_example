import 'package:backend/models/messages.dart';
import 'package:backend/models/user.dart';
import 'package:fennec_pg/fennec_pg.dart';

import '../models/chat.dart';

class UserRepository extends Repository<User, int> {}

class ChatRepository extends Repository<Chat, String> {}

class MessagesRepository extends Repository<Messages, int> {}
