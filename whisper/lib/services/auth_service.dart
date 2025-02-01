import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign up method with error handling.
  Future<UserCredential?> signUp(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException in signUp: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      print('Error in signUp: $e');
      return null;
    }
  }

  Future<UserCredential?> login(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException in login: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      print('Error in login: $e');
      return null;
    }
  }

  // Logout method with error handling.
  Future<bool> logout() async {
    try {
      await _auth.signOut();
      return true;
    } catch (e) {
      print('Error in logout: $e');
      return false;
    }
  }
}
