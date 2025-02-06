import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/repositories/user_repository.dart';
import '../data/models/user_model.dart';

part 'auth_service.g.dart';

class AuthService {
  final FirebaseAuth _auth;
  final UserRepository _userRepository;

  AuthService(this._auth, this._userRepository);

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<AppUser> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = AppUser(
      uid: credential.user!.uid,
      email: email,
      displayName: displayName,
      joinDate: DateTime.now(),
    );

    await _userRepository.updateUser(user);
    return user;
  }

  Future<void> signOut() async => await _auth.signOut();

  Future<void> updateProfileImage(String uid, String url) async {
    await _userRepository.updateUser(
        (await _userRepository.getUser(uid)).copyWith(profileImageUrl: url));
  }
}

@riverpod
AuthService authService(AuthServiceRef ref) {
  return AuthService(
    FirebaseAuth.instance,
    ref.read(userRepositoryProvider),
  );
}
