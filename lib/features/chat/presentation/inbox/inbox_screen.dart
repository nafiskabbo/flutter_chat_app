import 'package:chat/config/routes/routes.dart';
import 'package:chat/features/auth/data/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  List<dynamic> _chats = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchChats();
  }

  Future<void> _fetchChats() async {
    // Fetch chats for the logged-in user
    final response = await Supabase.instance.client
        .from('chats')
        .select('*, messages(*)')
        .or('user_1.eq.${Supabase.instance.client.auth.currentUser!.id}, user_2.eq.${Supabase.instance.client.auth.currentUser!.id}')
        .order('created_at', ascending: false);

    setState(() {
      _chats = response ?? [];
      _isLoading = false;
    });
  }

  void _navigateToChat(String chatId) {
    context.pushNamed(
      Routes.chat.name,
      pathParameters: {"chatId": chatId},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inbox'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              AuthService().signOut();
              context.goNamed(Routes.login.name);
            },
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _chats.length,
              itemBuilder: (context, index) {
                final chat = _chats[index];
                final lastMessage = chat['messages'].isNotEmpty
                    ? chat['messages'].last['content']
                    : 'No messages yet';

                final otherUserId = chat['user_1'] == Supabase.instance.client.auth.currentUser!.id
                    ? chat['user_2']
                    : chat['user_1'];

                return ListTile(
                  title: Text('Chat with User ID: $otherUserId'),
                  subtitle: Text(lastMessage),
                  onTap: () => _navigateToChat(chat['id']),
                );
              },
            ),
    );
  }
}
