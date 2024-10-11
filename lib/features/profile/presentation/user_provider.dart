import 'package:chat/features/profile/data/model/user_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final userProvider = FutureProvider<List<UserData>>((ref) async {
  final currentUser = Supabase.instance.client.auth.currentUser;
  if (currentUser == null) throw Exception("User not authenticated");

  try {
    final response =
        await Supabase.instance.client.from('users').select('*').neq('id', currentUser.id);
    return response.map((user) => UserData.fromMap(user)).toList();
  } catch (e) {
    throw Exception('Failed to load users. $e');
  }
});

final currentUserProvider = Provider<UserData>((ref) {
  // Logic to provide current user data from Supabase
  final user = Supabase.instance.client.auth.currentUser;
  return UserData(id: user!.id, email: user.email ?? '');
});
