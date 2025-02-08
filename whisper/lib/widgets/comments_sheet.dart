import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../features/models/comment_model.dart';
import '../providers/comments_provider.dart';
import 'comment_tile.dart';

class CommentsSheet extends ConsumerStatefulWidget {
  final String postId;

  const CommentsSheet({super.key, required this.postId});

  @override
  ConsumerState<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends ConsumerState<CommentsSheet> {
  final _controller = TextEditingController();
  final _auth = FirebaseAuth.instance;
  CommentModel? _replyingTo;

  @override
  void initState() {
    super.initState();
    // Remove the initial load since we're using streamProvider
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ref.read(commentsProvider.notifier).loadCommentsForPost(widget.postId);
    // });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startReply(CommentModel comment) {
    setState(() {
      _replyingTo = comment;
      // Don't set text with @ mention, just focus the field
      _controller.clear();
    });
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
  }

  void _cancelReply() {
    setState(() {
      _replyingTo = null;
      _controller.clear();
    });
  }

  Future<void> _handleAddComment() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (!mounted) return;

      final userData = userDoc.data() ?? {};

      // Match UniversalPostCard fallback:
      final displayName = [
        userData['displayName']?.toString().trim(),
        userData['username']?.toString().trim(),
        currentUser.displayName?.trim(),
      ].whereType<String>().firstWhere(
            (name) => name.isNotEmpty,
            orElse: () => 'Anonymous',
          );

      final profileImage = [
        userData['photoUrl']?.toString(),
        userData['photoURL']?.toString(),
        userData['profileImage']?.toString(),
        userData['avatar']?.toString(),
        userData['coverImage']?.toString(),
        currentUser.photoURL,
      ].whereType<String>().firstWhere(
            (url) => url.trim().isNotEmpty,
            orElse: () =>
                'https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y',
          );

      final comment = CommentModel(
        id: FirebaseFirestore.instance.collection('comments').doc().id,
        postId: widget.postId,
        authorId: currentUser.uid,
        authorName: displayName,
        authorImage: profileImage,
        content: text,
        createdAt: DateTime.now(),
        likesCount: 0,
        likedBy: [],
        authorRole: userData['role'] ?? 'Member',
        parentId: _replyingTo?.id,
        replyToId: _replyingTo?.authorId,
        replyToName: _replyingTo?.authorName,
      );

      if (_replyingTo != null) {
        await ref
            .read(commentsProvider.notifier)
            .addReply(_replyingTo!, comment);
      } else {
        await ref.read(commentsProvider.notifier).addComment(comment);
      }

      if (!mounted) return;
      _controller.clear();
      _cancelReply(); // Clear reply state
      ref.invalidate(commentsStreamProvider(widget.postId));
    } catch (e) {
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(
        SnackBar(
          content: Text('Failed to add comment: ${e.toString()}'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final commentsAsyncValue = ref.watch(commentsStreamProvider(widget.postId));
    final theme = Theme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const _CommentsHeader(),
          Expanded(
            child: commentsAsyncValue.when(
              data: (comments) {
                if (comments.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 64,
                          color:
                              theme.colorScheme.onBackground.withOpacity(0.4),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Start the conversation\nBe the first to comment!',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color:
                                theme.colorScheme.onBackground.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    final currentUser = FirebaseAuth.instance.currentUser;
                    final isLiked = currentUser != null &&
                        comment.likedBy.contains(currentUser.uid);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: CommentTile(
                        comment: comment,
                        isLiked: isLiked,
                        onLikePressed: () {
                          ref
                              .read(commentsProvider.notifier)
                              .toggleLike(comment.id);
                        },
                        onReplyPressed: () => _startReply(comment),
                        showReplies: true,
                        replies: ref
                                .watch(commentRepliesProvider(comment.id))
                                .value ??
                            [],
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading comments...'),
                  ],
                ),
              ),
              error: (error, stack) {
                debugPrint('Error loading comments: $error\n$stack');
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      const Text(
                        'Failed to load comments\nPlease try again',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          ref.invalidate(commentsStreamProvider(widget.postId));
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (_replyingTo != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Replying to ${_replyingTo!.authorName}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _cancelReply,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
          Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, -1),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    onSubmitted: (_) => _handleAddComment(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _handleAddComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentsHeader extends StatelessWidget {
  const _CommentsHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          const Text(
            'Comments',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
