import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the FirebaseAuth instance.
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

/// A stream provider that listens to Firebase authentication state changes.
/// It emits the current [User] if signed in, or `null` otherwise.
final authStateProvider = StreamProvider<User?>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return firebaseAuth.authStateChanges();
});

/// AuthService encapsulates authentication logic using FirebaseAuth.
class AuthService {
  final FirebaseAuth _firebaseAuth;
  AuthService(this._firebaseAuth);

  /// Signs in a user with email and password.
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Signs up a new user with email and password.
  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
    // You can add additional parameters (e.g., display name) if needed.
  }) async {
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}

/// Provides an instance of AuthService.
final authServiceProvider = Provider<AuthService>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return AuthService(firebaseAuth);
});
