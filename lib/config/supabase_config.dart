/// Fill these in with your own Supabase project's values.
///
/// Dashboard -> Project Settings -> API:
///   - "Project URL"      -> [url]
///   - "anon public" key  -> [anonKey]
///
/// The anon key is safe to ship in a client app — it's a public key. Access
/// control is enforced server-side by the Row Level Security policies in
/// supabase/schema.sql, not by keeping this key secret.
class SupabaseConfig {
  static const String url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://vogmvmskhkwrdaxdgfvt.supabase.co',
  );

  static const String anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZvZ212bXNraGt3cmRheGRnZnZ0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODMwNzA3NjUsImV4cCI6MjA5ODY0Njc2NX0.fhnj19NFT1__-wfpNBby9hu0wg-JyrfpNc3SoWNuDHQ',
  );

  /// True once the placeholders above have been replaced with real values.
  static bool get isConfigured =>
      !url.contains('YOUR-PROJECT-REF') && !anonKey.contains('YOUR-ANON-KEY');
}
