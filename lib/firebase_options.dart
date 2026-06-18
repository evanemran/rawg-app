import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Firebase configuration generated from the registered Android and iOS apps.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web is not configured for Firebase.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'Firebase is only configured for Android and iOS.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDUXDNDPWx_59JJFxbcAKu36YBVNduqwzI',
    appId: '1:793566773716:android:b3d879a8f5b792a430d641',
    messagingSenderId: '793566773716',
    projectId: 'rawg-fb',
    storageBucket: 'rawg-fb.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC2jCcZGuQcUy7-rIQ3yg0rrztQhhfYxKU',
    appId: '1:793566773716:ios:c89235f14d67d3bc30d641',
    messagingSenderId: '793566773716',
    projectId: 'rawg-fb',
    storageBucket: 'rawg-fb.firebasestorage.app',
    iosBundleId: 'com.evanemran.rawgApp',
  );
}
