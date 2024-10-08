import 'package:chat/config/routes/routes.dart';
import 'package:chat/features/auth/data/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilesScreen extends StatefulWidget {
  const ProfilesScreen({super.key});

  @override
  State<ProfilesScreen> createState() => _ProfilesScreenState();
}

class _ProfilesScreenState extends State<ProfilesScreen> {
  List<dynamic> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    // Fetch all users from the users table
    final response = await Supabase.instance.client
        .from('users')
        .select('*')
        .neq('id', Supabase.instance.client.auth.currentUser!.id); // Exclude the logged-in user

    setState(() {
      _users = response ?? [];
      _isLoading = false;
    });
  }

  Future<void> _startChat(String otherUserId) async {
    // Check if a chat already exists between the users
    final existingChatResponse = await Supabase.instance.client
        .from('chats')
        .select('id')
        .or('user_1.eq.$otherUserId, user_2.eq.$otherUserId')
        .eq('user_1', Supabase.instance.client.auth.currentUser!.id)
        .single();

    String chatId;
    if (existingChatResponse != null) {
      chatId = existingChatResponse['id'];
    } else {
      // Create a new chat
      final newChatResponse = await Supabase.instance.client
          .from('chats')
          .insert({
            'user_1': Supabase.instance.client.auth.currentUser!.id,
            'user_2': otherUserId,
          })
          .select()
          .single();

      chatId = newChatResponse['id'];
    }

    // Navigate to the chat screen
    context.pushNamed(
      Routes.chat.name,
      pathParameters: {"chatId": chatId},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profiles'),
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
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return ListTile(
                  title: Text('User ID: ${user['id']}'),
                  subtitle: Text('Email: ${user['email']}'),
                  onTap: () => _startChat(user['id']),
                );
              },
            ),
    );
  }
}
