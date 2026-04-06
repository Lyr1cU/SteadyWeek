/// Compile-time cloud configuration (optional).
///
/// Run / build with:
/// `--dart-define=SUPABASE_URL=https://xxxx.supabase.co --dart-define=SUPABASE_ANON_KEY=eyJ...`
///
/// If either value is empty, the app stays **offline-first** (current default): no Supabase init,
/// auth screen shows the existing “coming soon” path for sign-in.
class CloudEnv {
  CloudEnv._();

  static const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );

  static const supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );

  static bool get isSupabaseConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}
