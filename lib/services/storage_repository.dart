import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';

/// Handles uploading project artwork to the public `portfolio` bucket in
/// Supabase Storage. Requires the bucket to exist and be marked Public, and
/// the storage RLS policies from supabase/schema.sql to be applied.
class StorageRepository {
  static const bucket = 'portfolio';

  /// Uploads [bytes] under a unique file name and returns its public URL.
  static Future<String> uploadImage({
    required Uint8List bytes,
    required String fileName,
  }) async {
    final safeName = fileName.replaceAll(RegExp(r'[^\w.\-]'), '_');
    final path = '${DateTime.now().millisecondsSinceEpoch}_$safeName';

    await SupabaseService.client.storage.from(bucket).uploadBinary(
          path,
          bytes,
          fileOptions: const FileOptions(upsert: false),
        );

    return SupabaseService.client.storage.from(bucket).getPublicUrl(path);
  }
}
