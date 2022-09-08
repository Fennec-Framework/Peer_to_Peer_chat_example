import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/models/message.dart';
import 'package:frontend/repository/messages_repository.dart';

import '../clients/socket_io_client.dart';
import '../models/chat.dart';
import '../models/user.dart';
import 'dart:ui' as ui;

class MessagesPage extends StatefulWidget {
  final Chat chat;
  final User currentUser;

  const MessagesPage({Key? key, required this.chat, required this.currentUser})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MessagesPageState();
  }
}

class _MessagesPageState extends State<MessagesPage> {
  List<Message> messages = [];
  bool loading = false;
  final MessagesRepository messagesRepository = MessagesRepository();
  SocketIoClient socketIoClient = SocketIoClient();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    _loadMessages();
    listenToRealTime();

    super.initState();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) => {
          if (scrollController.hasClients)
            {
              scrollController.animateTo(
                  scrollController.position.maxScrollExtent + 30,
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeIn)
            },
        });
  }

  void listenToRealTime() {
    socketIoClient.socket.off("realtime/chat/${widget.chat.chatId}/messages");
    socketIoClient.socket.on("realtime/chat/${widget.chat.chatId}/messages",
        (data) {
      if (data['event'] == 'create') {
        Message message = Message.fromJson(data['data']);
        setState(() {
          messages.add(message);
        });
        _scrollToEnd();
      }
    });
  }

  Future _loadMessages() async {
    setState(() {
      loading = true;
    });
    messages = await messagesRepository.loadMessages(widget.chat.chatId);
    if (!mounted) {
      return;
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 249, 253, 1),
      extendBody: true,
      bottomSheet: Container(
        padding: const EdgeInsets.only(bottom: 20),
        child: TextInputField(
          currentUser: widget.currentUser,
          chatId: widget.chat.chatId,
          receiverUser: widget.currentUser.id == widget.chat.firstUser.id
              ? widget.chat.secondUser
              : widget.chat.firstUser,
        ),
      ),
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
      body: loading
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.deepPurple,
            ))
          : ListView.builder(
              controller: scrollController,
              itemCount: messages.length,
              padding: const EdgeInsets.only(bottom: 60, left: 20, right: 20),
              itemBuilder: (_, index) {
                Message message = messages[index];
                bool isMine = message.from == widget.currentUser.id;
                return isMine
                    ? OutBubble(
                        message: message.content,
                      )
                    : InBubble(message: message.content);
                ;
              }),
    );
  }
}

class Triangle extends CustomPainter {
  final Color backgroundColor;

  Triangle(this.backgroundColor);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = backgroundColor;

    var path = Path();
    path.lineTo(-5, 0);
    path.lineTo(0, 10);
    path.lineTo(5, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class OutBubble extends StatelessWidget {
  final String message;

  const OutBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              color: Colors.indigo.shade600,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(19),
                bottomLeft: Radius.circular(19),
                bottomRight: Radius.circular(19),
              ),
            ),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ),
        CustomPaint(painter: Triangle(Colors.indigo.shade600)),
      ],
    );
  }
}

class InBubble extends StatelessWidget {
  final String message;

  const InBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(pi),
          child: CustomPaint(
            painter: Triangle(Colors.grey.shade300),
          ),
        ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(19),
                bottomLeft: Radius.circular(19),
                bottomRight: Radius.circular(19),
              ),
            ),
            child: Text(
              message,
              style: const TextStyle(color: Colors.black, fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }
}

class TextInputField extends StatefulWidget {
  final String chatId;
  final User currentUser;
  final User receiverUser;

  const TextInputField(
      {Key? key,
      required this.chatId,
      required this.currentUser,
      required this.receiverUser})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TextInputField();
  }
}

class _TextInputField extends State<TextInputField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final MessagesRepository messagesRepository = MessagesRepository();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: _controller,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(0.0),
          hintText: 'type your message ....',
          labelStyle: const TextStyle(
            color: Colors.black,
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
          ),
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 14.0,
          ),
          suffixIcon: IconButton(
            onPressed: _controller.text.isEmpty
                ? null
                : () async {
                    final result = await messagesRepository.sendMessage(
                        widget.chatId,
                        widget.currentUser.id,
                        widget.receiverUser.id,
                        _controller.text);
                  },
            icon: const Icon(
              Icons.send_rounded,
              size: 20,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
            borderRadius: BorderRadius.circular(10.0),
          ),
          floatingLabelStyle: const TextStyle(
            color: Colors.black,
            fontSize: 18.0,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black, width: 1.5),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}
