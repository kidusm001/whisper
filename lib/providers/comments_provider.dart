import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/models/comment_model.dart';

class CommentsNotifier extends StateNotifier<Map<String, List<CommentModel>>> {
  CommentsNotifier() : super({});

  void addComment(CommentModel comment) {
    final postId = comment.postId;
    final currentComments = state[postId] ?? [];
    state = {
      ...state,
      postId: [...currentComments, comment],
    };
  }

  List<CommentModel> getCommentsForPost(String postId) {
    return state[postId] ?? [];
  }
}

final commentsProvider =
    StateNotifierProvider<CommentsNotifier, Map<String, List<CommentModel>>>(
        (ref) {
  return CommentsNotifier();
});
