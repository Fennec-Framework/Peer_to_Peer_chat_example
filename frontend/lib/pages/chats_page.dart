import 'package:flutter/material.dart';
import 'package:frontend/pages/messages_page.dart';
import 'package:frontend/repository/chat_repository.dart';

import '../clients/socket_io_client.dart';
import '../models/chat.dart';
import '../models/user.dart';
import '../utils/utils.dart';

class ChatsPage extends StatefulWidget {
  final User currentUser;

  const ChatsPage({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ChatsPageState();
  }
}

class _ChatsPageState extends State<ChatsPage> {
  List<Chat> chats = [];
  bool loading = false;
  final ChatRepository chatRepository = ChatRepository();

  @override
  void initState() {
    _loadChats();
    listenToRealTime();
    super.initState();
  }

  Future _loadChats() async {
    setState(() {
      loading = true;
    });
    chats = await chatRepository.loadChats(widget.currentUser.id);
    setState(() {
      loading = false;
    });
  }

  SocketIoClient socketIoClient = SocketIoClient();

  void listenToRealTime() {
    socketIoClient.socket.off("realtime/chats");
    socketIoClient.socket.on("realtime/chats", (data) {
      if (data['event'] == 'update') {
        Chat chat = Chat.fromJson(data['data']);
        int index =
            chats.indexWhere((element) => element.chatId == chat.chatId);
        setState(() {
          if (index != -1) {
            chats[index] = chat;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: const Text(
          'Chats',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: ListView.builder(
          itemCount: chats.length,
          itemBuilder: (_, index) {
            User receiverUser =
                chats[index].firstUser.id == widget.currentUser.id
                    ? chats[index].secondUser
                    : chats[index].firstUser;
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MessagesPage(
                              chat: chats[index],
                              currentUser: widget.currentUser,
                            )));
              },
              child: Container(
                color: Colors.white,
                child: ListTile(
                  leading: CircleAvatar(
                      backgroundColor:
                          Utils.getColorByString(receiverUser.username),
                      child: Text(
                        receiverUser.username.length >= 2
                            ? receiverUser.username
                                .substring(0, 2)
                                .toUpperCase()
                            : "SA",
                      )),
                  title: Text(
                    receiverUser.username,
                  ),
                  subtitle: (chats[index].lastMessage != null)
                      ? Text(
                          chats[index].lastMessage!.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )
                      : null,
                ),
              ),
            );
          }),
    );
  }
}
