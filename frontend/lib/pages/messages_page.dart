import 'package:flutter/material.dart';
import 'package:frontend/models/message.dart';
import 'package:frontend/repository/messages_repository.dart';

import '../models/chat.dart';

class MessagesPage extends StatefulWidget {
  final Chat chat;

  const MessagesPage({Key? key, required this.chat}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MessagesPageState();
  }
}

class _MessagesPageState extends State<MessagesPage> {
  List<Message> messages = [];
  bool loading = false;
  final MessagesRepository messagesRepository = MessagesRepository();

  @override
  void initState() {
    _loadMessages();
    super.initState();
  }

  Future _loadMessages() async {
    setState(() {
      loading = true;
    });
    messages = await messagesRepository.loadMessages(widget.chat.chatId);
    setState(() {
      loading = false;
    });
    print(messages);
  }

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
          'Messages',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
