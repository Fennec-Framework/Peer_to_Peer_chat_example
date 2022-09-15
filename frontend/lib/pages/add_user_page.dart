import 'package:flutter/material.dart';
import 'package:frontend/models/chat.dart';
import 'package:frontend/repository/chat_repository.dart';

import '../models/user.dart';
import '../utils/utils.dart';
import 'messages_page.dart';

class AddUserPage extends StatefulWidget {
  final User currentUser;

  const AddUserPage({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AddUserPageState();
  }
}

class _AddUserPageState extends State<AddUserPage> {
  final ChatRepository _chatRepository = ChatRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              size: 30,
              color: Colors.blue,
            )),
        elevation: 0,
        backgroundColor: Colors.black,
        title: const Text(
          'Add User',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: FutureBuilder<List<User>>(
        future: _chatRepository.getUsers(widget.currentUser.id),
        builder: (_, users) {
          if (!users.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
                value: 10,
              ),
            );
          } else if (users.data == null || users.data!.isEmpty) {
            return const Center(
              child: Text(
                "No Users Found",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            );
          }
          return ListView.separated(
              itemCount: users.data!.length,
              separatorBuilder: (_, __) {
                return const Divider(
                  height: 3,
                );
              },
              itemBuilder: (_, index) {
                User user = users.data![index];
                return InkWell(
                  onTap: () {
                    Chat chat = Chat(Utils.chatHashedCodeId(
                        firstUserId: widget.currentUser.id.toString(),
                        secondUserId: user.id.toString()));
                    chat.firstUser = widget.currentUser;
                    chat.secondUser = user;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MessagesPage(
                                  newChat: true,
                                  chat: chat,
                                  currentUser: widget.currentUser,
                                )));
                  },
                  child: Container(
                    color: Colors.white,
                    child: ListTile(
                      leading: CircleAvatar(
                          backgroundColor:
                              Utils.getColorByString(user.username),
                          child: Text(
                            user.username.length >= 2
                                ? user.username.substring(0, 2).toUpperCase()
                                : "SA",
                          )),
                      title: Text(
                        user.username,
                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
