import 'package:chat/config/routes/routes.dart';
import 'package:chat/features/auth/data/auth_service.dart';
import 'package:chat/features/chat/presentation/chat_provider.dart';
import 'package:chat/features/profile/presentation/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfilesScreen extends ConsumerWidget {
  const ProfilesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsyncValue = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profiles'),
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
      body: RefreshIndicator.adaptive(
        onRefresh: () => ref.refresh(userProvider.future),
        child: usersAsyncValue.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => const Center(child: Text('Failed to load users.')),
          data: (users) {
            if (users.isEmpty) {
              return const Center(child: Text('No data available.'));
            }
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.person),
                  ),
                  title: Text(user.email),
                  subtitle: Text('User ID: ${user.id}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.message),
                    onPressed: () => _startChat(context, ref, user.id ?? ''),
                    tooltip: 'Send Message',
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  // Function to start chat with another user
  Future<void> _startChat(BuildContext context, WidgetRef ref, String otherUserId) async {
    final startChatAsyncValue = ref.read(startChatProvider(otherUserId).future);

    startChatAsyncValue.then((chatId) {
      // Navigate to the chat screen with the obtained chat ID
      if (context.mounted) {
        context.pushNamed(
          Routes.chat.name,
          queryParameters: {"chatId": chatId},
        );
      }
    }).catchError((error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error starting chat: $error')),
        );
      }
    });
  }
}
