import 'package:challengeme/components/specialistTopbar.dart';
import 'package:challengeme/components/styles.dart';
import 'package:challengeme/components/topBar.dart';
import 'package:challengeme/models/message.dart';
import 'package:challengeme/models/user.dart';
import 'package:challengeme/services/messageService.dart';
import 'package:challengeme/services/sessionService.dart';
import 'package:challengeme/services/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:challengeme/components/fromMessageCard.dart';
import 'package:challengeme/components/toMessageCard.dart';

class ChatView extends StatefulWidget {
  final User to;
  const ChatView({super.key, required this.to});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Message> messages = [];
  bool _loaded = false;
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loadMessages();
    }
  }

  Future<void> _loadMessages() async {
    setState(() {
      _loaded = false;
    });

    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      _loaded = true;
    });

    final from =
        Provider.of<SessionService>(context, listen: false).currentUser;

    if (from == null) {
      showWarning(context, 'Session Expired. Please login again');
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      return;
    }

    final result = await MessageService.getMessages(from.id, widget.to.id);

    if (result == null) {
      showWarning(
          context, 'Failed to load the messages. Try reloading the page');
      return;
    }

    // for (Message m in result) {
    //   print(m);
    // }

    setState(() {
      messages = result;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final from =
        Provider.of<SessionService>(context, listen: false).currentUser;

    PreferredSizeWidget topBar;

    if (from != null && from.role == 'user') {
      topBar = TopBar();
    } else {
      topBar = SpecialistTopBar();
    }

    return Scaffold(
      appBar: topBar,
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Header bar
                Container(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 10, left: 0, right: 20),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1475AD),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: back,
                          icon: const Icon(Icons.arrow_back, size: 25),
                          padding: EdgeInsets.zero,
                          color: Colors.white,
                          constraints: const BoxConstraints(),
                        ),
                      ),
                      Text(
                        widget.to.name,
                        style: title08(26),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Messages list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isFromMe = message.from.id == from?.id;

                      if (isFromMe) {
                        return Column(
                          children: [
                            FromMessageCard(
                              message: message,
                              refreshCallback: () => _loadMessages(),
                            ),
                            const SizedBox(height: 2)
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            ToMessageCard(message: message),
                            const SizedBox(height: 2)
                          ],
                        );
                      }
                    },
                  ),
                ),

                // Message input area
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          decoration: InputDecoration(
                            hintText: "Type your message...",
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: sendMessage,
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(12),
                          backgroundColor: const Color(0xFF1475AD),
                        ),
                        child: const Icon(Icons.send,
                            size: 20, color: Colors.white),
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  void back() {
    Navigator.pop(context);
  }

  void delete(String messageId) async {
    print('Deleting $messageId');
    return;
  }

  void sendMessage() async {
    String msg = messageController.text.trim();
    if (msg == '') {
      return;
    }
    final from =
        Provider.of<SessionService>(context, listen: false).currentUser;

    if (from == null) {
      showWarning(context, 'Session Expired. Please login again');
      return;
    }
    Message? message =
        await MessageService.sendMessage(msg, from.id, widget.to.id);

    if (message == null) {
      showWarning(context, 'Failed to send the message');
      return;
    }

    messageController.text = '';

    _loadMessages();
  }
}
