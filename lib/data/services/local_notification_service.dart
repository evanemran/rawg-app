import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class LocalNotificationService {
  static const _channelId = 'rawg_default';
  static const _channelName = 'RAWG Notifications';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );

    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      importance: Importance.high,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> requestPermission() async {
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
      return;
    }

    final iosPlugin = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (iosPlugin != null) {
      await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  Future<void> show({
    required int id,
    required String title,
    required String body,
    String? imageUrl,
  }) async {
    const defaultAndroidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      importance: Importance.high,
      priority: Priority.high,
    );
    const defaultIosDetails = DarwinNotificationDetails();

    var androidDetails = defaultAndroidDetails;
    var iosDetails = defaultIosDetails;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      final bytes = await _downloadImageBytes(imageUrl);
      if (bytes != null) {
        if (!kIsWeb && Platform.isAndroid) {
          final bitmap = ByteArrayAndroidBitmap(bytes);
          androidDetails = AndroidNotificationDetails(
            _channelId,
            _channelName,
            importance: Importance.high,
            priority: Priority.high,
            styleInformation: BigPictureStyleInformation(
              bitmap,
              largeIcon: bitmap,
              contentTitle: title,
              summaryText: body,
              hideExpandedLargeIcon: true,
            ),
          );
        }

        if (!kIsWeb && Platform.isIOS) {
          final attachmentPath = await _saveImageForIos(id, bytes);
          if (attachmentPath != null) {
            iosDetails = DarwinNotificationDetails(
              attachments: [
                DarwinNotificationAttachment(
                  attachmentPath,
                  hideThumbnail: false,
                ),
              ],
            );
          }
        }
      }
    }

    await _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      ),
    );
  }

  Future<Uint8List?> _downloadImageBytes(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200 && response.bodyBytes.isNotEmpty) {
        return response.bodyBytes;
      }
    } catch (e) {
      debugPrint('Notification image download failed: $e');
    }
    return null;
  }

  Future<String?> _saveImageForIos(int id, Uint8List bytes) async {
    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/notification_$id.jpg');
      await file.writeAsBytes(bytes, flush: true);
      return file.path;
    } catch (e) {
      debugPrint('Notification image file save failed: $e');
      return null;
    }
  }
}
