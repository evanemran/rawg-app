import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';

import 'data/repositories/notification_repository_impl.dart';
import 'data/services/local_notification_service.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) return;

  final repository = NotificationRepositoryImpl(
    FirebaseFirestore.instance,
  );
  await repository.saveNotificationFromMessage(userId, message);

  if (message.notification == null) {
    final parsed = NotificationRepositoryImpl.parseRemoteMessage(message);
    if (parsed.title.isEmpty && parsed.body.isEmpty) return;

    final localNotifications = LocalNotificationService();
    await localNotifications.initialize();
    await localNotifications.show(
      id: message.hashCode,
      title: parsed.title,
      body: parsed.body,
      imageUrl: parsed.imageUrl,
    );
  }
}
