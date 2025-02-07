import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/models/post_model.dart';
import '../../features/models/comment_model.dart';
import '../../providers/comments_provider.dart';
import '../../providers/comment_likes_provider.dart';

class CommentScreen extends ConsumerStatefulWidget {
  final PostModel post;

  const CommentScreen({
    super.key,
    required this.post,
  });

  @override
  ConsumerState<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends ConsumerState<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _addComment() {
    if (_commentController.text.trim().isEmpty) return;

    final newComment = CommentModel(
      id: DateTime.now().toString(), // This should be generated by the backend
      postId: widget.post.id,
      authorId: 'currentUserId', // This should come from auth
      authorName: 'Current User', // This should come from auth
      content: _commentController.text.trim(),
      createdAt: DateTime.now(),
    );

    ref.read(commentsProvider.notifier).addComment(newComment);
    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final comments = ref.watch(commentsProvider)[widget.post.id] ?? [];
    final commentLikes = ref.watch(commentLikesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                final isLiked = commentLikes.likedComments[comment.id] ?? false;
                final likeCount =
                    commentLikes.likeCounts[comment.id] ?? comment.likesCount;

                return ListTile(
                  leading: const CircleAvatar(
                    backgroundImage:
                        NetworkImage('https://placeholder.com/50x50'),
                  ),
                  title: Text(comment.authorName ?? 'Anonymous'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(comment.content),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '${comment.createdAt.toString().split('.')[0]}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$likeCount likes',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked
                          ? Colors.red
                          : Theme.of(context).iconTheme.color,
                    ),
                    onPressed: () {
                      ref.read(commentLikesProvider.notifier).toggleLike(
                            comment.id,
                            comment.likesCount,
                          );
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: null,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _addComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
