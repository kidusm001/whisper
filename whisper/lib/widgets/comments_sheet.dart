import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../features/models/comment_model.dart';
import '../providers/comments_provider.dart';

class CommentsSheet extends ConsumerStatefulWidget {
  final String postId;

  const CommentsSheet({super.key, required this.postId});

  @override
  ConsumerState<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends ConsumerState<CommentsSheet> {
  final _controller = TextEditingController();
  final _auth = FirebaseAuth.instance;

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

  Future<void> _handleAddComment(BuildContext context) async {
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

      final comment = CommentModel(
        id: FirebaseFirestore.instance.collection('comments').doc().id,
        postId: widget.postId,
        authorId: currentUser.uid,
        authorName: userData['displayName'] ?? userData['username'],
        authorImage: userData['photoUrl'] ?? userData['profileImage'],
        content: text,
        createdAt: DateTime.now(),
        likesCount: 0,
        likedBy: [],
      );

      await ref.read(commentsProvider.notifier).addComment(comment);
      if (!mounted) return;

      _controller.clear();
      // Force refresh comments
      ref.refresh(commentsStreamProvider(widget.postId));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
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

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                        const Icon(
                          Icons.chat_bubble_outline,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No comments yet\nBe the first to comment!',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Icon(
                          Icons.arrow_downward,
                          color: Theme.of(context).primaryColor,
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
                      child: _CommentTile(
                        comment: comment,
                        isLiked: isLiked,
                        likeCount: comment.likesCount,
                        onLikePressed: () {
                          ref
                              .read(commentsProvider.notifier)
                              .toggleLike(comment.id);
                        },
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
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _handleAddComment(context),
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

class _CommentTile extends StatelessWidget {
  final CommentModel comment;
  final bool isLiked;
  final int likeCount;
  final VoidCallback onLikePressed;

  const _CommentTile({
    required this.comment,
    required this.isLiked,
    required this.likeCount,
    required this.onLikePressed,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(comment.authorId)
          .get(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final userData =
            userSnapshot.data?.data() as Map<String, dynamic>? ?? {};

        // Combine comment data with user data for display
        final String displayName = comment.authorName?.toString().trim() ??
            userData['displayName']?.toString().trim() ??
            userData['username']?.toString().trim() ??
            'Anonymous';

        // Use the same profile image logic as UniversalPostCard
        final String profileImage = [
          if (comment.authorImage != null) comment.authorImage!,
          if (userData['photoUrl'] != null) userData['photoUrl'] as String,
          if (userData['photoURL'] != null) userData['photoURL'] as String,
          if (userData['profileImage'] != null)
            userData['profileImage'] as String,
          if (userData['avatar'] != null) userData['avatar'] as String,
          if (userData['coverImage'] != null) userData['coverImage'] as String,
        ].firstWhere((image) => image.trim().isNotEmpty,
            orElse: () =>
                'https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y');

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(profileImage),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(comment.content),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? Colors.red : Colors.grey,
                          ),
                          onPressed: onLikePressed,
                        ),
                        Text('$likeCount'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CommentInput extends StatefulWidget {
  final String postId;
  final void Function(CommentModel) onSubmit;

  const _CommentInput({
    required this.postId,
    required this.onSubmit,
  });

  @override
  State<_CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<_CommentInput> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
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
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send),
            color: Theme.of(context).colorScheme.primary,
            onPressed: () {
              final currentUser = FirebaseAuth.instance.currentUser;
              if (currentUser == null || _controller.text.trim().isEmpty) {
                return;
              }

              final comment = CommentModel(
                id: FirebaseFirestore.instance.collection('comments').doc().id,
                postId: widget.postId,
                authorId: currentUser.uid,
                authorName: currentUser.displayName ?? 'Anonymous',
                authorImage: currentUser.photoURL,
                content: _controller.text.trim(),
                createdAt: DateTime.now(),
              );

              widget.onSubmit(comment);
              _controller.clear();
            },
          ),
        ],
      ),
    );
  }
}
