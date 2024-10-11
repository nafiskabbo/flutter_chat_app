import 'package:chat/features/chat/data/models/chat_data.dart';
import 'package:chat/features/chat/data/models/message_data.dart';
import 'package:chat/features/profile/presentation/user_provider.dart';
// import 'package:chat/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Provider for fetching chat data
final chatProvider = StreamProvider<List<ChatData>>((ref) {
  final userId = ref.watch(currentUserProvider).id;
  return Supabase.instance.client
      .from('chats')
      .stream(primaryKey: ['id'])
      .order('updated_at', ascending: false)
      .map((data) {
        return data
            .map((json) => ChatData.fromMap(json))
            .where((chat) => chat.user1Id == userId || chat.user2Id == userId)
            .toList();
      });
});

// Provider for handling message streaming
final messageStreamProvider = StreamProvider.family<List<MessageData>, String>((ref, chatId) {
  // DateTime? lastHeaderDate;
  return Supabase.instance.client
      .from('messages')
      .stream(primaryKey: ['id'])
      .eq('chat_id', chatId)
      .order('created_at', ascending: false)
      .limit(100)
      .map((data) {
        // Map the raw data to MessageData objects
        final messages = data
            .map((json) => MessageData.fromMap(json))
            // .map((data) {
            // final messageDate = data.createdAt ?? DateTime.now();
            // logger.i("nope: ${data.content} | ${messageDate} | $lastHeaderDate");
            // if (lastHeaderDate == null || !_isSameDay(messageDate, lastHeaderDate!)) {
            //   // Assign this message's date as a new header date
            //   lastHeaderDate = messageDate; // Update lastHeaderDate
            //   return MessageData(
            //     id: data.id,
            //     chatId: data.chatId,
            //     senderId: data.senderId,
            //     content: data.content,
            //     createdAt: data.createdAt,
            //     headerDate: messageDate, // Set the headerDate for the new day
            //   );
            // } else {
            //   // Keep the headerDate as null (no new header)
            //   return MessageData(
            //     id: data.id,
            //     chatId: data.chatId,
            //     senderId: data.senderId,
            //     content: data.content,
            //     createdAt: data.createdAt,
            //     headerDate: null, // No header for same-day messages
            //   );
            // }
            // })
            .toList();
        return messages;
      });
});

bool _isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
}

// Function to create or retrieve a chat ID, then navigate to the chat screen
final startChatProvider = FutureProvider.family<String, String>((ref, otherUserId) async {
  final currentUserId = Supabase.instance.client.auth.currentUser?.id;
  if (currentUserId == null) throw Exception("User not authenticated");

  final response = await Supabase.instance.client
      .from('chats')
      .select('id')
      .or('and(user1_id.eq.$currentUserId, user2_id.eq.$otherUserId), '
          'and(user1_id.eq.$otherUserId, user2_id.eq.$currentUserId)')
      .maybeSingle();

  if (response != null) {
    return response['id'];
  } else {
    final newChatResponse = await Supabase.instance.client
        .from('chats')
        .insert({
          'user1_id': currentUserId,
          'user2_id': otherUserId,
        })
        .select('id')
        .single();

    return newChatResponse['id'];
  }
});
