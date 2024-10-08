// import 'package:chat/features/profile/data/model/profile.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// final profilesProvider = StateNotifierProvider<ProfilesNotifier, List<Profile>>((ref) {
//   return ProfilesNotifier();
// });

// class ProfilesNotifier extends StateNotifier<List<Profile>> {
//   ProfilesNotifier() : super([]);

//   Future<void> fetchProfiles() async {
//     final response = await Supabase.instance.client.from('profiles').select().execute();
//     if (response.error == null) {
//       state = response.data.map((json) => Profile.fromJson(json)).toList();
//     }
//   }
// }
