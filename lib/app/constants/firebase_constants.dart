/// Firebase-related constants shared across the data layer.
class FirebaseConstants {
  FirebaseConstants._();

  static const String usersCollection = 'users';
  static const String collectionSubcollection = 'collection';
  static const String notificationsSubcollection = 'notifications';

  /// Web client ID (OAuth client type 3) used for Google Sign-In on Android.
  static const String googleWebClientId =
      '793566773716-s4hu3a7q8v852l50sn7g92nd108rphnm.apps.googleusercontent.com';
}
