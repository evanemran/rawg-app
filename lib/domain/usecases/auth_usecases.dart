import '../models/app_user.dart';
import '../repositories/auth_repository.dart';

class SignInWithEmail {
  final AuthRepository _repository;

  SignInWithEmail(this._repository);

  Future<AppUser> call({
    required String email,
    required String password,
  }) =>
      _repository.signInWithEmail(email: email, password: password);
}

class RegisterWithEmail {
  final AuthRepository _repository;

  RegisterWithEmail(this._repository);

  Future<AppUser> call({
    required String name,
    required String email,
    required String password,
  }) =>
      _repository.registerWithEmail(
        name: name,
        email: email,
        password: password,
      );
}

class SignInWithGoogle {
  final AuthRepository _repository;

  SignInWithGoogle(this._repository);

  Future<AppUser> call() => _repository.signInWithGoogle();
}

class SignOut {
  final AuthRepository _repository;

  SignOut(this._repository);

  Future<void> call() => _repository.signOut();
}

class WatchUserProfile {
  final AuthRepository _repository;

  WatchUserProfile(this._repository);

  Stream<AppUser?> call(String userId) =>
      _repository.watchUserProfile(userId);
}
