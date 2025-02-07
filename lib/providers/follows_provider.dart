import 'package:flutter_riverpod/flutter_riverpod.dart';

class FollowState {
  final Map<String, bool> following;
  final Map<String, String>
      subscriptionTiers; // stores the tier level for each followed creator

  FollowState({
    Map<String, bool>? following,
    Map<String, String>? subscriptionTiers,
  })  : following = following ?? {},
        subscriptionTiers = subscriptionTiers ?? {};

  FollowState copyWith({
    Map<String, bool>? following,
    Map<String, String>? subscriptionTiers,
  }) {
    return FollowState(
      following: following ?? this.following,
      subscriptionTiers: subscriptionTiers ?? this.subscriptionTiers,
    );
  }
}

class FollowsNotifier extends StateNotifier<FollowState> {
  FollowsNotifier() : super(FollowState());

  bool isFollowing(String creatorId) => state.following[creatorId] ?? false;

  void followCreator(String creatorId, String tier) {
    state = state.copyWith(
      following: {
        ...state.following,
        creatorId: true,
      },
      subscriptionTiers: {
        ...state.subscriptionTiers,
        creatorId: tier,
      },
    );
  }

  void unfollowCreator(String creatorId) {
    final newFollowing = Map<String, bool>.from(state.following)
      ..remove(creatorId);
    final newTiers = Map<String, String>.from(state.subscriptionTiers)
      ..remove(creatorId);

    state = state.copyWith(
      following: newFollowing,
      subscriptionTiers: newTiers,
    );
  }
}

final followsProvider =
    StateNotifierProvider<FollowsNotifier, FollowState>((ref) {
  return FollowsNotifier();
});
