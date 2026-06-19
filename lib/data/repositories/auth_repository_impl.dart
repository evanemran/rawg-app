import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../app/constants/firebase_constants.dart';
import '../../domain/models/app_user.dart';
import '../../domain/models/auth_exception.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  AuthRepositoryImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required GoogleSignIn googleSignIn,
  })  : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  @override
  Stream<String?> get authStateChanges =>
      _auth.authStateChanges().map((user) => user?.uid);

  @override
  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw const AuthException('Sign in failed. Please try again.');
      }
      await _ensureUserDocument(user);
      return _requireUserProfile(user.uid);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseAuthError(e));
    }
  }

  @override
  Future<AppUser> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw const AuthException('Registration failed. Please try again.');
      }
      await user.updateDisplayName(name.trim());
      await _createUserDocument(
        userId: user.uid,
        name: name.trim(),
        email: user.email ?? email.trim(),
        profilePicture: user.photoURL,
      );
      return _requireUserProfile(user.uid);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseAuthError(e));
    }
  }

  @override
  Future<AppUser> signInWithGoogle() async {
    try {
      final account = await _googleSignIn.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null) {
        throw const AuthException('Google sign in failed. Please try again.');
      }

      final credential = GoogleAuthProvider.credential(idToken: idToken);
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) {
        throw const AuthException('Google sign in failed. Please try again.');
      }

      await _ensureUserDocument(
        user,
        name: account.displayName,
        profilePicture: account.photoUrl,
      );
      return _requireUserProfile(user.uid);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw const AuthException('Google sign in was cancelled.');
      }
      throw AuthException(e.description ?? 'Google sign in failed.');
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseAuthError(e));
    }
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  @override
  Stream<AppUser?> watchUserProfile(String userId) {
    return _users.doc(userId).snapshots().map(_mapUserDocument);
  }

  Future<void> _ensureUserDocument(
    User user, {
    String? name,
    String? profilePicture,
  }) async {
    final doc = await _users.doc(user.uid).get();
    if (doc.exists) return;

    await _createUserDocument(
      userId: user.uid,
      name: name ?? user.displayName ?? _fallbackName(user.email),
      email: user.email ?? '',
      profilePicture: profilePicture ?? user.photoURL,
    );
  }

  Future<void> _createUserDocument({
    required String userId,
    required String name,
    required String email,
    String? profilePicture,
  }) {
    return _users.doc(userId).set({
      'name': name,
      'email': email,
      'profilePicture': profilePicture,
      'joiningDate': FieldValue.serverTimestamp(),
    });
  }

  Future<AppUser> _requireUserProfile(String userId) async {
    final doc = await _users.doc(userId).get();
    final user = _mapUserDocument(doc);
    if (user == null) {
      throw const AuthException('User profile not found.');
    }
    return user;
  }

  AppUser? _mapUserDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    if (!doc.exists) return null;
    final data = doc.data();
    if (data == null) return null;

    final joiningDate = data['joiningDate'];
    if (joiningDate is! Timestamp) return null;

    return AppUser(
      id: doc.id,
      name: data['name'] as String? ?? '',
      email: data['email'] as String? ?? '',
      profilePicture: data['profilePicture'] as String?,
      joiningDate: joiningDate.toDate(),
    );
  }

  String _fallbackName(String? email) {
    if (email == null || email.isEmpty) return 'Player';
    return email.split('@').first;
  }

  String _mapFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'operation-not-allowed':
        return 'This sign in method is not enabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return e.message ?? 'Authentication failed. Please try again.';
    }
  }
}
