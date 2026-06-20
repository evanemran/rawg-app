import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/notification_repository_impl.dart';
import '../../data/services/fcm_service.dart';
import '../../data/services/local_notification_service.dart';
import '../../domain/models/app_notification.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../domain/usecases/notification_usecases.dart';
import 'auth_provider.dart';

final localNotificationServiceProvider = Provider<LocalNotificationService>(
  (ref) => LocalNotificationService(),
);

final firebaseMessagingProvider = Provider<FirebaseMessaging>(
  (ref) => FirebaseMessaging.instance,
);

final notificationRepositoryProvider = Provider<NotificationRepository>(
  (ref) => NotificationRepositoryImpl(ref.watch(firestoreProvider)),
);

final fcmServiceProvider = Provider<FcmService>(
  (ref) => FcmService(
    messaging: ref.watch(firebaseMessagingProvider),
    auth: ref.watch(firebaseAuthProvider),
    notificationRepository: ref.watch(notificationRepositoryProvider),
    localNotifications: ref.watch(localNotificationServiceProvider),
  ),
);

final watchNotificationsProvider = Provider<WatchNotifications>(
  (ref) => WatchNotifications(ref.watch(notificationRepositoryProvider)),
);

final watchUnreadNotificationCountProvider =
    Provider<WatchUnreadNotificationCount>(
  (ref) => WatchUnreadNotificationCount(
    ref.watch(notificationRepositoryProvider),
  ),
);

final markNotificationReadProvider = Provider<MarkNotificationRead>(
  (ref) => MarkNotificationRead(ref.watch(notificationRepositoryProvider)),
);

final markAllNotificationsReadProvider = Provider<MarkAllNotificationsRead>(
  (ref) => MarkAllNotificationsRead(ref.watch(notificationRepositoryProvider)),
);

final saveFcmTokenProvider = Provider<SaveFcmToken>(
  (ref) => SaveFcmToken(ref.watch(notificationRepositoryProvider)),
);

final clearFcmTokenProvider = Provider<ClearFcmToken>(
  (ref) => ClearFcmToken(ref.watch(notificationRepositoryProvider)),
);

final notificationsProvider = StreamProvider<List<AppNotification>>((ref) {
  final userId = ref.watch(authStateProvider).value;
  if (userId == null) return Stream.value(const []);

  return ref.watch(watchNotificationsProvider)(userId);
});

final unreadNotificationCountProvider = StreamProvider<int>((ref) {
  final userId = ref.watch(authStateProvider).value;
  if (userId == null) return Stream.value(0);

  return ref.watch(watchUnreadNotificationCountProvider)(userId);
});
