import 'package:chat/features/chat/presentation/chat_provider.dart';
import 'package:chat/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatScreen extends ConsumerWidget {
  final String chatId;

  ChatScreen({super.key, required this.chatId});

  final TextEditingController _messageController = TextEditingController();
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    _messageController.clear();

    try {
      await supabase.from('messages').insert({
        'chat_id': chatId,
        'sender_id': supabase.auth.currentUser!.id,
        'content': message,
      });

      // Update the last_message and updated_at timestamp in the chats table
      await supabase.from('chats').update({
        'last_message': message,
        'updated_at': DateTime.now().toIso8601String(), // Use current timestamp
      }).eq('id', chatId);
    } catch (e) {
      logger.e("Error sending message: $e");
    }
  }

  String _formatTimestamp(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime).inDays;

    if (difference == 0 && now.day == dateTime.day) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference == 2) {
      return '2 days ago';
    } else {
      return DateFormat('yyyy-MM-dd').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageStream = ref.watch(messageStreamProvider(chatId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: messageStream.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => const Center(child: Text('Error loading messages')),
              data: (messages) {
                if (messages.isEmpty) {
                  return const Center(child: Text('No messages yet'));
                }

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final messageDate = message.createdAt ?? DateTime.now();
                    final isCurrentUser = message.senderId == supabase.auth.currentUser!.id;
                    // logger.w("date: ${message.headerDate}");

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (message.headerDate != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Center(
                              child: Text(
                                _formatTimestamp(message.headerDate!),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        Align(
                          alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            child: Row(
                              mainAxisAlignment:
                                  isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (!isCurrentUser) ...[
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.grey[200],
                                    child: const Icon(Icons.person, color: Colors.black),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                                Flexible(
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: isCurrentUser
                                            ? [Colors.deepPurpleAccent, Colors.deepPurple]
                                            : [Colors.grey[300]!, Colors.grey[200]!],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: isCurrentUser
                                          ? CrossAxisAlignment.end
                                          : CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          message.content,
                                          style: TextStyle(
                                            color: isCurrentUser ? Colors.white : Colors.black87,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          DateFormat('yyyy-MM-dd hh:mm a').format(messageDate),
                                          // DateFormat('hh:mm a').format(messageDate),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: isCurrentUser ? Colors.white70 : Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (isCurrentUser) ...[
                                  const SizedBox(width: 8),
                                  const CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.deepPurple,
                                    child: Icon(Icons.person),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          SendMessageView(
            messageController: _messageController,
            sendMessage: _sendMessage,
          ),
        ],
      ),
    );
  }
}

class SendMessageView extends StatelessWidget {
  final TextEditingController messageController;
  final void Function() sendMessage;

  const SendMessageView({
    super.key,
    required this.messageController,
    required this.sendMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              onSubmitted: (_) => sendMessage(),
            ),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: sendMessage,
            backgroundColor: Colors.deepPurpleAccent,
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
