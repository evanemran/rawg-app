import '../models/app_notification.dart';
import '../repositories/notification_repository.dart';

class WatchNotifications {
  final NotificationRepository _repository;

  WatchNotifications(this._repository);

  Stream<List<AppNotification>> call(String userId) =>
      _repository.watchNotifications(userId);
}

class WatchUnreadNotificationCount {
  final NotificationRepository _repository;

  WatchUnreadNotificationCount(this._repository);

  Stream<int> call(String userId) => _repository.watchUnreadCount(userId);
}

class MarkNotificationRead {
  final NotificationRepository _repository;

  MarkNotificationRead(this._repository);

  Future<void> call(String userId, String notificationId) =>
      _repository.markAsRead(userId, notificationId);
}

class MarkAllNotificationsRead {
  final NotificationRepository _repository;

  MarkAllNotificationsRead(this._repository);

  Future<void> call(String userId) => _repository.markAllAsRead(userId);
}

class SaveFcmToken {
  final NotificationRepository _repository;

  SaveFcmToken(this._repository);

  Future<void> call(String userId, String token) =>
      _repository.saveFcmToken(userId, token);
}

class ClearFcmToken {
  final NotificationRepository _repository;

  ClearFcmToken(this._repository);

  Future<void> call(String userId) => _repository.clearFcmToken(userId);
}
