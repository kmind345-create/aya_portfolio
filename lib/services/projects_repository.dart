import '../config/supabase_config.dart';
import '../models/project.dart';
import 'supabase_service.dart';

class ProjectsRepository {
  static Future<List<Project>> fetchAll() async {
    if (!SupabaseConfig.isConfigured) return [];
    final data = await SupabaseService.client
        .from('projects')
        .select()
        .order('sort_order', ascending: true);
    return (data as List)
        .map((row) => Project.fromMap(row as Map<String, dynamic>))
        .toList();
  }

  static Future<void> create(Project project) async {
    await SupabaseService.client.from('projects').insert(project.toInsertMap());
  }

  static Future<void> update(String id, Project project) async {
    await SupabaseService.client
        .from('projects')
        .update(project.toInsertMap())
        .eq('id', id);
  }

  static Future<void> delete(String id) async {
    await SupabaseService.client.from('projects').delete().eq('id', id);
  }
}
