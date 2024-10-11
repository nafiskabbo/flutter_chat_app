import 'package:chat/config/routes/routes.dart';
import 'package:chat/features/auth/data/auth_service.dart';
import 'package:chat/features/chat/presentation/chat_provider.dart';
import 'package:chat/features/profile/presentation/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class InboxScreen extends ConsumerWidget {
  const InboxScreen({super.key});

  // Navigate to the chat screen with the chat ID
  void _navigateToChat(BuildContext context, String chatId) {
    context.pushNamed(
      Routes.chat.name,
      queryParameters: {"chatId": chatId},
    );
  }

  // Format timestamp for display
  String _formatTimestamp(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime).inDays;

    if (difference == 0 && now.day == dateTime.day) {
      // If it's today, show only the time
      return DateFormat('hh:mm a').format(dateTime);
    } else if (difference == 1) {
      // If it's yesterday, show "Yesterday"
      return 'Yesterday';
    } else if (difference == 2) {
      // If it's 2 days ago, show "2 days ago"
      return '2 days ago';
    } else {
      // Otherwise, show the date
      return DateFormat('yyyy-MM-dd').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatStream = ref.watch(chatProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              AuthService().signOut();
              context.goNamed(Routes.login.name);
            },
          ),
        ],
      ),
      body: chatStream.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => const Center(child: Text('Error loading chats')),
        data: (chats) {
          if (chats.isEmpty) {
            return const Center(child: Text('No chats available.'));
          }
          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              final lastMessageTimestamp =
                  chat.updatedAt != null ? _formatTimestamp(chat.updatedAt!) : '';
              final otherUserId =
                  chat.user1Id == ref.read(currentUserProvider).id ? chat.user2Id : chat.user1Id;

              return ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.person),
                ),
                title: Text('Chat with User ID: $otherUserId'),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(chat.lastMessage ?? 'No messages yet')),
                    const SizedBox(width: 8),
                    Text(
                      lastMessageTimestamp,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                onTap: () => _navigateToChat(context, chat.id ?? ''),
              );
            },
          );
        },
      ),
    );
  }
}
