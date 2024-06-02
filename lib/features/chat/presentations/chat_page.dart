import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konsul/features/auth/bloc/auth_cubit.dart';
import 'package:konsul/features/chat/model/chat.dart';
import 'package:konsul/features/chat/presentations/chat_item.dart';
import 'package:konsul/helpers/dialog.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(this.uid, {super.key});

  final String uid;
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String? userId;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool isLoadingChat = false;

  @override
  void initState() {
    super.initState();
    userId = context.read<AuthCubit>().state.userId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .where('roomId', isEqualTo: widget.uid)
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                        child: Container(
                            margin: const EdgeInsets.all(16),
                            child: Text('Error: ${snapshot.error}')));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final chats = snapshot.data!.docs
                      .map((doc) => doc.data() as Map<String, dynamic>)
                      .toList();

                  return ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      final doc = snapshot.data!.docs[index];
                      Chat chat =
                          Chat.fromJson(chats[index]).copyWith(id: doc.id);
                      bool isMe = chat.userId == userId;
                      if (index == chats.length - 1) {
                        return Column(
                          children: [
                            const SizedBox(height: 32),
                            ChatItem(isMe: isMe, chat: chat),
                          ],
                        );
                      } else {
                        return ChatItem(isMe: isMe, chat: chat);
                      }
                    },
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Ketik pesan anda...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.surface,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4.0,
                          spreadRadius: 2.0,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.send,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      createMessage(context, userId, _controller.text);
                      setState(() {
                        _controller.clear();
                        _scrollToBottom();
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void createMessage(
      BuildContext context, String? userId, String message) async {
    try {
      if (userId == null) {
        throw Exception('User ID is null');
      }
      setState(() {
        isLoadingChat = true;
      });
      await FirebaseFirestore.instance.collection('chats').add({
        'roomId': widget.uid,
        'userId': userId,
        'chat': message,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialogMsg(context, 'Error : ${e.toString()}');
      });
    } finally {
      setState(() {
        isLoadingChat = false;
      });
    }
  }
}
