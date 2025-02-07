import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentLikesState {
  final Map<String, bool> likedComments;
  final Map<String, int> likeCounts;

  CommentLikesState({
    Map<String, bool>? likedComments,
    Map<String, int>? likeCounts,
  })  : likedComments = likedComments ?? {},
        likeCounts = likeCounts ?? {};

  CommentLikesState copyWith({
    Map<String, bool>? likedComments,
    Map<String, int>? likeCounts,
  }) {
    return CommentLikesState(
      likedComments: likedComments ?? this.likedComments,
      likeCounts: likeCounts ?? this.likeCounts,
    );
  }
}

class CommentLikesNotifier extends StateNotifier<CommentLikesState> {
  CommentLikesNotifier() : super(CommentLikesState());

  void toggleLike(String commentId, int initialCount) {
    final isLiked = state.likedComments[commentId] ?? false;
    final currentCount = state.likeCounts[commentId] ?? initialCount;

    state = state.copyWith(
      likedComments: {
        ...state.likedComments,
        commentId: !isLiked,
      },
      likeCounts: {
        ...state.likeCounts,
        commentId: currentCount + (isLiked ? -1 : 1),
      },
    );
  }

  bool isLiked(String commentId) => state.likedComments[commentId] ?? false;
  int getLikeCount(String commentId, int defaultCount) =>
      state.likeCounts[commentId] ?? defaultCount;
}

final commentLikesProvider =
    StateNotifierProvider<CommentLikesNotifier, CommentLikesState>((ref) {
  return CommentLikesNotifier();
});
