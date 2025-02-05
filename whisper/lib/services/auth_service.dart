import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  static const String _userKey = 'current_user';
  final SharedPreferences _prefs;

  AuthService(this._prefs);

  Future<UserModel?> getCurrentUser() async {
    final userJson = _prefs.getString(_userKey);
    if (userJson == null) return null;
    return UserModel.fromJson(jsonDecode(userJson));
  }

  Future<void> updateUser(UserModel user) async {
    await _prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  Future<bool> login(String email, String password) async {
    // For demo purposes, accept any email/password
    if (email.isNotEmpty && password.isNotEmpty) {
      final user = UserModel(
        uid: '1',
        email: email,
        displayName: email.split('@')[0],
        isCreator: false,
      );
      await _prefs.setString(_userKey, jsonEncode(user.toJson()));
      return true;
    }
    return false;
  }

  Future<bool> signUp(String email, String password, String name) async {
    final user = UserModel(
      uid: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      displayName: name,
      isCreator: false,
    );
    await _prefs.setString(_userKey, jsonEncode(user.toJson()));
    return true;
  }

  Future<void> logout() async {
    await _prefs.remove(_userKey);
  }
}
