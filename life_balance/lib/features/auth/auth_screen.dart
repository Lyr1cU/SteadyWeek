import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:life_balance/cloud/cloud_env.dart';
import 'package:life_balance/l10n/app_localizations.dart';
import 'package:life_balance/providers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Cloud auth via Supabase when configured (dart-defines); otherwise offline message.
class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  var _busy = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _onSignIn(AppLocalizations l10n) async {
    final client = ref.read(supabaseClientProvider);
    final messenger = ScaffoldMessenger.of(context);

    if (client == null || !CloudEnv.isSupabaseConfigured) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.authComingSoon)));
      return;
    }

    final email = _email.text.trim();
    final password = _password.text;
    if (email.isEmpty || password.isEmpty) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.authSignInFailed)));
      return;
    }

    setState(() => _busy = true);
    try {
      await client.auth.signInWithPassword(email: email, password: password);
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(l10n.authSignedIn)));
      context.pop();
    } on AuthException catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(e.message.isNotEmpty ? e.message : l10n.authSignInFailed),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(l10n.authSignInFailed)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasCloud = CloudEnv.isSupabaseConfigured;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.authTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            hasCloud ? l10n.authSubtitle : l10n.authComingSoon,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          if (hasCloud) ...[
            const SizedBox(height: 24),
            TextField(
              controller: _email,
              decoration: InputDecoration(
                labelText: l10n.authEmailHint,
              ),
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              enabled: !_busy,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _password,
              decoration: InputDecoration(
                labelText: l10n.authPasswordHint,
              ),
              obscureText: true,
              enabled: !_busy,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _busy ? null : () => _onSignIn(l10n),
              child: _busy
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.authSignIn),
            ),
          ],
          const SizedBox(height: 8),
          TextButton(
            onPressed: _busy ? null : () => context.pop(),
            child: Text(l10n.authContinueOffline),
          ),
        ],
      ),
    );
  }
}
