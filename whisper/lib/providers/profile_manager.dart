import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/user_model.dart';
import '../data/repositories/user_repository.dart';

part 'profile_manager.g.dart';

@riverpod
class ProfileManager extends _$ProfileManager {
  UserRepository get _userRepository => ref.read(userRepositoryProvider);

  Future<void> updateProfile({
    required String uid,
    String? displayName,
    String? profileImageUrl,
    Map<String, String>? socialLinks,
  }) async {
    final currentUser = await _userRepository.getUser(uid);
    await _userRepository.updateUser(
      currentUser.copyWith(
        displayName: displayName ?? currentUser.displayName,
        profileImageUrl: profileImageUrl ?? currentUser.profileImageUrl,
        socialLinks: socialLinks ?? currentUser.socialLinks,
      ),
    );
  }

  Future<void> upgradeToCreator(String uid) async {
    await _userRepository.upgradeToCreator(uid);
  }

  Future<void> updateSubscriptionTier(String uid, SubscriptionTier tier) async {
    await _userRepository.updateTier(uid, tier);
  }

  @override
  build() => this;
}
