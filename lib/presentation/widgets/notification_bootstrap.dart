import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import '../providers/notification_provider.dart';

/// Initializes FCM and syncs the device token when the user is signed in.
class NotificationBootstrap extends ConsumerStatefulWidget {
  final Widget child;

  const NotificationBootstrap({super.key, required this.child});

  @override
  ConsumerState<NotificationBootstrap> createState() =>
      _NotificationBootstrapState();
}

class _NotificationBootstrapState extends ConsumerState<NotificationBootstrap> {
  String? _lastUserId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _setup());
  }

  Future<void> _setup() async {
    await ref.read(fcmServiceProvider).initialize();
    _syncAuth(ref.read(authStateProvider).value);
  }

  void _syncAuth(String? userId) {
    if (userId == _lastUserId) return;
    final previousUserId = _lastUserId;
    _lastUserId = userId;

    if (previousUserId != null && previousUserId != userId) {
      ref.read(fcmServiceProvider).clearTokenForUser(previousUserId);
    }
    if (userId != null) {
      ref.read(fcmServiceProvider).syncTokenForUser(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authStateProvider, (previous, next) {
      _syncAuth(next.value);
    });

    return widget.child;
  }
}
