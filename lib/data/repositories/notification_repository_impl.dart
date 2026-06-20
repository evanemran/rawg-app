import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../app/constants/firebase_constants.dart';
import '../../domain/models/app_notification.dart';
import '../../domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final FirebaseFirestore _firestore;

  NotificationRepositoryImpl(this._firestore);

  CollectionReference<Map<String, dynamic>> _notificationsRef(String userId) {
    return _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(userId)
        .collection(FirebaseConstants.notificationsSubcollection);
  }

  DocumentReference<Map<String, dynamic>> _userRef(String userId) {
    return _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(userId);
  }

  @override
  Stream<List<AppNotification>> watchNotifications(String userId) {
    return _notificationsRef(userId)
        .orderBy('createdAt', descending: true)
        .limit(100)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => _fromFirestore(doc.id, doc.data()))
              .whereType<AppNotification>()
              .toList(),
        );
  }

  @override
  Stream<int> watchUnreadCount(String userId) {
    return _notificationsRef(userId)
        .where('read', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  @override
  Future<void> saveNotification({
    required String userId,
    required String title,
    required String body,
    String? messageId,
    String? imageUrl,
  }) async {
    if (title.isEmpty && body.isEmpty) return;

    final docId = messageId ?? _firestore.collection('_').doc().id;
    final docRef = _notificationsRef(userId).doc(docId);

    final existing = await docRef.get();
    if (existing.exists) return;

    await docRef.set({
      'title': title,
      'body': body,
      'read': false,
      'createdAt': FieldValue.serverTimestamp(),
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (messageId != null) 'messageId': messageId,
    });
  }

  Future<void> saveNotificationFromMessage(
    String userId,
    RemoteMessage message,
  ) {
    final parsed = parseRemoteMessage(message);
    return saveNotification(
      userId: userId,
      title: parsed.title,
      body: parsed.body,
      messageId: parsed.messageId,
      imageUrl: parsed.imageUrl,
    );
  }

  @override
  Future<void> markAsRead(String userId, String notificationId) {
    return _notificationsRef(userId).doc(notificationId).update({
      'read': true,
    });
  }

  @override
  Future<void> markAllAsRead(String userId) async {
    final snapshot = await _notificationsRef(userId)
        .where('read', isEqualTo: false)
        .get();

    if (snapshot.docs.isEmpty) return;

    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      batch.update(doc.reference, {'read': true});
    }
    await batch.commit();
  }

  @override
  Future<void> saveFcmToken(String userId, String token) {
    return _userRef(userId).set({
      'fcmToken': token,
      'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Future<void> clearFcmToken(String userId) {
    return _userRef(userId).update({
      'fcmToken': FieldValue.delete(),
    });
  }

  AppNotification? _fromFirestore(String id, Map<String, dynamic> data) {
    final createdAt = data['createdAt'];
    if (createdAt is! Timestamp) return null;

    return AppNotification(
      id: id,
      title: data['title'] as String? ?? '',
      body: data['body'] as String? ?? '',
      createdAt: createdAt.toDate(),
      read: data['read'] as bool? ?? false,
      imageUrl: data['imageUrl'] as String?,
    );
  }

  static ({String title, String body, String? messageId, String? imageUrl})
      parseRemoteMessage(RemoteMessage message) {
    final notification = message.notification;
    return (
      title: notification?.title ?? message.data['title'] ?? 'Notification',
      body: notification?.body ?? message.data['body'] ?? '',
      messageId: message.messageId,
      imageUrl: notification?.android?.imageUrl ??
          notification?.apple?.imageUrl ??
          message.data['imageUrl'] ??
          message.data['image'],
    );
  }
}