import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient client;

  AuthService() : client = Supabase.instance.client;

  Future<String?> signUp(String email, String password) async {
    try {
      final response = await client.auth.signUp(email: email, password: password);

      if (response.user == null) {
        return 'Sign-up failed. Please try again.';
      }

      // Add user to the 'users' table
      final userId = response.user!.id;
      await client.from('users').insert({
        'id': userId,
        'email': email,
      });

      return null; // Sign-up successful
    } catch (e) {
      return e.toString(); // Return error message
    }
  }

  Future<String?> signIn(String email, String password) async {
    try {
      final response = await client.auth.signInWithPassword(email: email, password: password);

      if (response.session == null) {
        return 'Login failed. Please check your credentials.';
      }
      return null; // Login successful
    } catch (e) {
      return e.toString(); // Return error message
    }
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  User? getCurrentUser() {
    return client.auth.currentUser;
  }
}
