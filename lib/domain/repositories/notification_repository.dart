import '../models/app_notification.dart';

abstract class NotificationRepository {
  Stream<List<AppNotification>> watchNotifications(String userId);

  Stream<int> watchUnreadCount(String userId);

  Future<void> saveNotification({
    required String userId,
    required String title,
    required String body,
    String? messageId,
    String? imageUrl,
  });

  Future<void> markAsRead(String userId, String notificationId);

  Future<void> markAllAsRead(String userId);

  Future<void> saveFcmToken(String userId, String token);

  Future<void> clearFcmToken(String userId);
}
