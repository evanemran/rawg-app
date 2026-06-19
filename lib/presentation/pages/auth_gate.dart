import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../providers/auth_provider.dart';
import 'app_shell.dart';
import 'auth_page.dart';

/// Routes users to [AuthPage] or [AppShell] based on Firebase auth state.
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.accent,
            ),
          ),
        ),
      ),
      error: (_, _) => const AuthPage(),
      data: (userId) => userId == null ? const AuthPage() : const AppShell(),
    );
  }
}
