import '../models/app_user.dart';

abstract class AuthRepository {
  Stream<String?> get authStateChanges;

  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  });

  Future<AppUser> registerWithEmail({
    required String name,
    required String email,
    required String password,
  });

  Future<AppUser> signInWithGoogle();

  Future<void> signOut();

  Stream<AppUser?> watchUserProfile(String userId);
}
