import '../config/supabase_config.dart';
import '../models/contact_message.dart';
import 'supabase_service.dart';

class MessagesRepository {
  static Future<void> send({
    required String name,
    required String email,
    required String message,
  }) async {
    if (!SupabaseConfig.isConfigured) {
      throw Exception('Supabase is not configured yet.');
    }
    await SupabaseService.client.from('messages').insert({
      'name': name,
      'email': email,
      'message': message,
    });
  }

  static Future<List<ContactMessage>> fetchAll() async {
    if (!SupabaseConfig.isConfigured) return [];
    final data = await SupabaseService.client
        .from('messages')
        .select()
        .order('created_at', ascending: false);
    return (data as List)
        .map((row) => ContactMessage.fromMap(row as Map<String, dynamic>))
        .toList();
  }

  static Future<void> markRead(String id, bool isRead) async {
    await SupabaseService.client
        .from('messages')
        .update({'is_read': isRead})
        .eq('id', id);
  }

  static Future<void> delete(String id) async {
    await SupabaseService.client.from('messages').delete().eq('id', id);
  }
}
