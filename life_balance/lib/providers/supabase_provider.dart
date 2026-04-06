import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:life_balance/cloud/supabase_bootstrap.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseClientProvider = Provider<SupabaseClient?>((ref) {
  return supabaseClientOrNull;
});

/// Auth session; emits again on sign-in / sign-out when Supabase is configured.
final supabaseSessionProvider = StreamProvider<Session?>((ref) async* {
  final client = ref.watch(supabaseClientProvider);
  if (client == null) {
    yield null;
    return;
  }
  yield client.auth.currentSession;
  await for (final event in client.auth.onAuthStateChange) {
    yield event.session;
  }
});
