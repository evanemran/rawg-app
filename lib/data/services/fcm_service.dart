import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../../domain/repositories/notification_repository.dart';
import '../repositories/notification_repository_impl.dart';
import 'local_notification_service.dart';

typedef MessageHandler = Future<void> Function(RemoteMessage message);

class FcmService {
  final FirebaseMessaging _messaging;
  final FirebaseAuth _auth;
  final NotificationRepository _notificationRepository;
  final LocalNotificationService _localNotifications;

  StreamSubscription<String>? _tokenRefreshSubscription;
  StreamSubscription<RemoteMessage>? _foregroundSubscription;
  StreamSubscription<RemoteMessage>? _openedAppSubscription;

  FcmService({
    required FirebaseMessaging messaging,
    required FirebaseAuth auth,
    required NotificationRepository notificationRepository,
    required LocalNotificationService localNotifications,
  })  : _messaging = messaging,
        _auth = auth,
        _notificationRepository = notificationRepository,
        _localNotifications = localNotifications;

  Future<void> initialize() async {
    await _localNotifications.initialize();
    await _localNotifications.requestPermission();
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    await _handleInitialMessage();
    _listenForegroundMessages();
    _listenOpenedAppMessages();
    _listenTokenRefresh();

    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      await syncTokenForUser(userId);
    }
  }

  Future<void> syncTokenForUser(String userId) async {
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        await _notificationRepository.saveFcmToken(userId, token);
      }
    } catch (e) {
      debugPrint('FCM token sync failed: $e');
    }
  }

  Future<void> clearTokenForUser(String userId) async {
    try {
      await _notificationRepository.clearFcmToken(userId);
      await _messaging.deleteToken();
    } catch (e) {
      debugPrint('FCM token clear failed: $e');
    }
  }

  Future<void> handleMessage(RemoteMessage message) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final parsed = NotificationRepositoryImpl.parseRemoteMessage(message);

    try {
      await _notificationRepository.saveNotification(
        userId: userId,
        title: parsed.title,
        body: parsed.body,
        messageId: parsed.messageId,
        imageUrl: parsed.imageUrl,
      );
    } catch (e) {
      debugPrint('FCM message persist failed: $e');
    }
  }

  Future<void> _handleInitialMessage() async {
    final message = await _messaging.getInitialMessage();
    if (message != null) {
      await handleMessage(message);
    }
  }

  void _listenForegroundMessages() {
    _foregroundSubscription?.cancel();
    _foregroundSubscription = FirebaseMessaging.onMessage.listen(
      (message) async {
        await handleMessage(message);

        final parsed = NotificationRepositoryImpl.parseRemoteMessage(message);
        if (parsed.title.isEmpty && parsed.body.isEmpty) return;

        await _localNotifications.show(
          id: message.hashCode,
          title: parsed.title,
          body: parsed.body,
          imageUrl: parsed.imageUrl,
        );
      },
    );
  }

  void _listenOpenedAppMessages() {
    _openedAppSubscription?.cancel();
    _openedAppSubscription =
        FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }

  void _listenTokenRefresh() {
    _tokenRefreshSubscription?.cancel();
    _tokenRefreshSubscription = _messaging.onTokenRefresh.listen(
      (token) async {
        final userId = _auth.currentUser?.uid;
        if (userId != null) {
          await _notificationRepository.saveFcmToken(userId, token);
        }
      },
    );
  }

  void dispose() {
    _tokenRefreshSubscription?.cancel();
    _foregroundSubscription?.cancel();
    _openedAppSubscription?.cancel();
  }
}
