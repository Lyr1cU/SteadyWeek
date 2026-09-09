import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:life_balance/cloud/cloud_env.dart';

bool _supabaseInitialized = false;

bool get isSupabaseInitialized => _supabaseInitialized;

/// Initializes Supabase when [CloudEnv.isSupabaseConfigured]. Safe to call if not configured.
Future<void> initSupabaseIfConfigured() async {
  if (!CloudEnv.isSupabaseConfigured) return;
  if (_supabaseInitialized) return;

  await Supabase.initialize(
    url: CloudEnv.supabaseUrl,
    anonKey: CloudEnv.supabaseAnonKey,
  );
  _supabaseInitialized = true;
}

/// Live client after init; `null` if cloud kit was not configured or init failed.
SupabaseClient? get supabaseClientOrNull {
  if (!_supabaseInitialized) return null;
  return Supabase.instance.client;
}
