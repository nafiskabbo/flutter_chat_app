// import 'package:chat/features/chat/data/models/chat.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// final chatsProvider = StateNotifierProvider<ChatsNotifier, List<Chat>>((ref) {
//   return ChatsNotifier();
// });

// class ChatsNotifier extends StateNotifier<List<Chat>> {
//   ChatsNotifier() : super([]);

//   Future<void> fetchChats() async {
//     final response = await Supabase.instance.client.from('chats').select().execute();
//     if (response.error == null) {
//       state = response.data.map((json) => Chat.fromJson(json)).toList();
//     }
//   }
// }
