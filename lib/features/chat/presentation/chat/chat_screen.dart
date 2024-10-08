import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;

  const ChatScreen({super.key, required this.chatId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<dynamic> _messages = [];
  bool _isLoading = true;
  late final Stream<List<Map<String, dynamic>>> _messageStream;

  @override
  void initState() {
    super.initState();
    _fetchMessages();
    _messageStream = _subscribeToMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  // Fetch previous messages from the database
  Future<void> _fetchMessages() async {
    final response = await Supabase.instance.client
        .from('messages')
        .select('*')
        .eq('chat_id', widget.chatId)
        .order('created_at', ascending: true)
        .limit(100);

    if (response != null) {
      setState(() {
        _messages = response; // Assign fetched messages
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      // Handle error or empty state
    }
  }

  // Subscribe to new messages using Supabase stream() API
  Stream<List<Map<String, dynamic>>> _subscribeToMessages() {
    return Supabase.instance.client
        .from('messages:chat_id=eq.${widget.chatId}')
        .stream(primaryKey: ['id']).order('created_at', ascending: true);
  }

  // Send a message to the database
  Future<void> _sendMessage() async {
    final message = _messageController.text;
    if (message.isEmpty) return;

    _messageController.clear();

    final response = await Supabase.instance.client.from('messages').insert({
      'chat_id': widget.chatId,
      'sender_id': Supabase.instance.client.auth.currentUser!.id,
      'content': message,
    }).select(); // Insert the message and return the result

    if (response != null && response.isNotEmpty) {
      setState(() {
        _messages.add(response.first); // Add the sent message to the UI
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : StreamBuilder<List<Map<String, dynamic>>>(
                    stream: _messageStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return const Center(child: Text('Error loading messages'));
                      }

                      final messages = snapshot.data ?? [];

                      return ListView.builder(
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final isCurrentUser =
                              message['sender_id'] == Supabase.instance.client.auth.currentUser!.id;

                          return Align(
                            alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 10,
                              ),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isCurrentUser ? Colors.blue[100] : Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(message['content']),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
