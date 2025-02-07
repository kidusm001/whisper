import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../features/models/comment_model.dart';
import '../providers/comment_likes_provider.dart';

class CommentTile extends ConsumerWidget {
  final CommentModel comment;
  final bool isLiked;
  final VoidCallback onLikePressed;
  final VoidCallback onReplyPressed;
  final bool showReplies;
  final List<CommentModel> replies;

  const CommentTile({
    super.key,
    required this.comment,
    required this.isLiked,
    required this.onLikePressed,
    required this.onReplyPressed,
    this.showReplies = false,
    this.replies = const [],
  });

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}w';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()}mo';
    } else {
      return '${(difference.inDays / 365).floor()}y';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final likes = ref.watch(commentLikesProvider);
    final currentLikeCount = likes.likeCounts[comment.id] ?? comment.likesCount;
    final timeAgo = _getTimeAgo(comment.createdAt);

    return FutureBuilder<DocumentSnapshot>(
      future: (comment.authorName == null || comment.authorImage == null)
          ? FirebaseFirestore.instance
              .collection('users')
              .doc(comment.authorId)
              .get()
          : null,
      builder: (context, snapshot) {
        // Get user data if available
        final userData = snapshot.data?.data() as Map<String, dynamic>? ?? {};

        // Use the same robust fallback logic as UniversalPostCard
        final displayName = comment.authorName ??
            [
              userData['displayName']?.toString().trim(),
              userData['username']?.toString().trim(),
            ].whereType<String>().firstWhere(
                  (name) => name.isNotEmpty,
                  orElse: () => 'Anonymous',
                );

        final profileImage = comment.authorImage ??
            [
              userData['photoUrl']?.toString(),
              userData['photoURL']?.toString(),
              userData['profileImage']?.toString(),
              userData['avatar']?.toString(),
              userData['coverImage']?.toString(),
            ].whereType<String>().firstWhere(
                  (url) => url.trim().isNotEmpty,
                  orElse: () =>
                      'https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y',
                );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(profileImage),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  displayName,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (comment.authorRole != null) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primaryContainer,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      comment.authorRole!,
                                      style:
                                          theme.textTheme.labelSmall?.copyWith(
                                        color: theme
                                            .colorScheme.onPrimaryContainer,
                                      ),
                                    ),
                                  ),
                                ],
                                const Spacer(),
                                Text(
                                  timeAgo,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            if (comment.replyToName != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  'Replying to @${comment.replyToName}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                            Text(
                              comment.content,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          size: 20,
                          color: isLiked
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                        ),
                        onPressed: onLikePressed,
                        visualDensity: VisualDensity.compact,
                      ),
                      Text(
                        currentLikeCount.toString(),
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(width: 16),
                      TextButton.icon(
                        onPressed: onReplyPressed,
                        icon: Icon(
                          Icons.reply,
                          size: 20,
                          color: theme.colorScheme.onSurface,
                        ),
                        label: Text(
                          'Reply',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (showReplies && replies.isNotEmpty) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 32),
                child: Column(
                  children: replies
                      .map((reply) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: CommentTile(
                              comment: reply,
                              isLiked: likes.likedComments[reply.id] ?? false,
                              onLikePressed: () => ref
                                  .read(commentLikesProvider.notifier)
                                  .toggleLike(reply.id, reply.likesCount),
                              onReplyPressed: () {},
                              showReplies: false,
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
