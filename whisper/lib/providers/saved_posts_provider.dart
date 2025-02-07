import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/models/post_model.dart';

class SavedPostsNotifier extends StateNotifier<List<PostModel>> {
  SavedPostsNotifier() : super([]);

  bool isPostSaved(PostModel post) {
    return state.any((savedPost) => savedPost.id == post.id);
  }

  void savePost(PostModel post) {
    if (!isPostSaved(post)) {
      state = [...state, post];
    }
  }

  void removePost(PostModel post) {
    state = state.where((savedPost) => savedPost.id != post.id).toList();
  }

  void togglePost(PostModel post) {
    if (isPostSaved(post)) {
      removePost(post);
    } else {
      savePost(post);
    }
  }
}

final savedPostsProvider =
    StateNotifierProvider<SavedPostsNotifier, List<PostModel>>((ref) {
  return SavedPostsNotifier();
});
