import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:life_balance/cloud/cloud_env.dart';
import 'package:life_balance/l10n/app_localizations.dart';
import 'package:life_balance/providers.dart';
import 'package:life_balance/ui/chrome_surfaces.dart';
import 'package:life_balance/ui/onboarding_typography.dart';
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
          content: Text(
            e.message.isNotEmpty ? e.message : l10n.authSignInFailed,
          ),
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
    final brightness = Theme.of(context).brightness;
    final tc = OnboardingTypography.textColor(brightness);
    final accent = OnboardingTypography.accentLavender;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: tc,
        iconTheme: IconThemeData(color: tc),
        title: Text(
          l10n.authTitle,
          style: OnboardingTypography.titleStyle(tc).copyWith(
            fontWeight: FontWeight.w700,
            fontSize: OnboardingTypography.welcome,
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const ChromePageBackground(),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                ChromeCard(
                  borderRadius: 22,
                  lightElevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          hasCloud ? l10n.authSubtitle : l10n.authComingSoon,
                          style: OnboardingTypography.bodyStyle(tc, alpha: 0.9),
                        ),
                        if (hasCloud) ...[
                          const SizedBox(height: 20),
                          TextField(
                            controller: _email,
                            style: OnboardingTypography.bodyStyle(tc),
                            decoration: InputDecoration(
                              labelText: l10n.authEmailHint,
                              labelStyle: OnboardingTypography.bodyStyle(
                                tc,
                                alpha: 0.72,
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            enabled: !_busy,
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _password,
                            style: OnboardingTypography.bodyStyle(tc),
                            decoration: InputDecoration(
                              labelText: l10n.authPasswordHint,
                              labelStyle: OnboardingTypography.bodyStyle(
                                tc,
                                alpha: 0.72,
                              ),
                            ),
                            obscureText: true,
                            enabled: !_busy,
                          ),
                          const SizedBox(height: 24),
                          FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: accent,
                              foregroundColor: const Color(0xFF1E1B4B),
                            ),
                            onPressed: _busy ? null : () => _onSignIn(l10n),
                            child: _busy
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(l10n.authSignIn),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: _busy ? null : () => context.pop(),
                  child: Text(
                    l10n.authContinueOffline,
                    style: OnboardingTypography.bodyStyle(tc, alpha: 0.92),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
