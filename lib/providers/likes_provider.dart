import 'package:flutter_riverpod/flutter_riverpod.dart';

class LikesState {
  final Map<String, bool> likedPosts;
  final Map<String, int> likeCounts;

  LikesState({
    Map<String, bool>? likedPosts,
    Map<String, int>? likeCounts,
  })  : likedPosts = likedPosts ?? {},
        likeCounts = likeCounts ?? {};

  LikesState copyWith({
    Map<String, bool>? likedPosts,
    Map<String, int>? likeCounts,
  }) {
    return LikesState(
      likedPosts: likedPosts ?? this.likedPosts,
      likeCounts: likeCounts ?? this.likeCounts,
    );
  }
}

class LikesNotifier extends StateNotifier<LikesState> {
  LikesNotifier() : super(LikesState());

  void toggleLike(String postId, int initialCount) {
    final isLiked = state.likedPosts[postId] ?? false;
    final currentCount = state.likeCounts[postId] ?? initialCount;

    state = state.copyWith(
      likedPosts: {
        ...state.likedPosts,
        postId: !isLiked,
      },
      likeCounts: {
        ...state.likeCounts,
        postId: currentCount + (isLiked ? -1 : 1),
      },
    );
  }

  bool isLiked(String postId) => state.likedPosts[postId] ?? false;
  int getLikeCount(String postId, int defaultCount) =>
      state.likeCounts[postId] ?? defaultCount;
}

final likesProvider = StateNotifierProvider<LikesNotifier, LikesState>((ref) {
  return LikesNotifier();
});
