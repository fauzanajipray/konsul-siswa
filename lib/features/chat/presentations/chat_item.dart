import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:konsul/features/chat/model/chat.dart';
import 'package:konsul/helpers/dialog.dart';
import 'package:konsul/helpers/helpers.dart';

class ChatItem extends StatelessWidget {
  const ChatItem({
    super.key,
    required this.isMe,
    required this.chat,
  });

  final bool isMe;
  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (isMe) {
          showDialogConfirmation(context, () => deleteMessage(context, chat.id),
              title: 'Konfirmasi', message: 'Apakah ingin mengapus data ini?');
        }
      },
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: IntrinsicWidth(
          child: Container(
            margin: isMe
                ? const EdgeInsets.fromLTRB(50, 8, 16, 4)
                : const EdgeInsets.fromLTRB(16, 8, 50, 4),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              color: isMe
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.tertiary,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4.0,
                  spreadRadius: 2.0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chat.chat ?? '-',
                  style: TextStyle(
                    color: isMe
                        ? Theme.of(context).colorScheme.onSecondary
                        : Theme.of(context).colorScheme.onTertiary,
                  ),
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    formatDateTimeCustom(chat.createdAt, format: 'HH:mm'),
                    style: TextStyle(
                      fontSize: 12,
                      color: isMe
                          ? Theme.of(context)
                              .colorScheme
                              .onSecondary
                              .withOpacity(0.5)
                          : Theme.of(context)
                              .colorScheme
                              .onTertiary
                              .withOpacity(0.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void deleteMessage(
    BuildContext context,
    String? uid,
  ) async {
    try {
      if (uid == null) {
        throw Exception('Chat ID is null');
      }
      await FirebaseFirestore.instance.collection('chats').doc(uid).delete();
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialogMsg(context, 'Error : ${e.toString()}');
      });
    }
  }
}
