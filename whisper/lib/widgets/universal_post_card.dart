import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:whisper/widgets/comments_sheet.dart'; // NEW IMPORT
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Add this import
import 'package:whisper/features/profile/screens/profile_view.dart';

class UniversalPostCard extends ConsumerStatefulWidget {
  final Map<String, dynamic> postData;
  const UniversalPostCard({super.key, required this.postData});

  @override
  ConsumerState<UniversalPostCard> createState() => _UniversalPostCardState();
}

class _UniversalPostCardState extends ConsumerState<UniversalPostCard>
    with SingleTickerProviderStateMixin {
  bool _isFollowing = false;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _checkIfFollowing();
  }

  Future<void> _checkIfFollowing() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null ||
          currentUser.uid == widget.postData['authorId']) {
        return;
      }
      final doc = await _firestore
          .collection('follows')
          .doc('${currentUser.uid}_${widget.postData['authorId']}')
          .get();
      if (doc.exists && mounted) {
        setState(() {
          _isFollowing = true;
        });
      }
    } catch (e) {
      debugPrint('Error checking follow status: $e');
      // Silently fail - don't show error to user
    }
  }

  Future<void> _followUser() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null || currentUser.uid == widget.postData['authorId']) {
      return;
    }

    setState(() => _isFollowing = true); // Optimistic update

    try {
      final batch = _firestore.batch();
      final followDocId = '${currentUser.uid}_${widget.postData['authorId']}';

      // Prepare follow document
      final followDoc = _firestore.collection('follows').doc(followDocId);
      batch.set(followDoc, {
        'followerId': currentUser.uid,
        'followingId': widget.postData['authorId'],
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Prepare counter updates
      final currentUserDoc =
          _firestore.collection('users').doc(currentUser.uid);
      final targetUserDoc =
          _firestore.collection('users').doc(widget.postData['authorId']);

      batch.update(currentUserDoc, {'followingCount': FieldValue.increment(1)});

      batch.update(targetUserDoc, {'followersCount': FieldValue.increment(1)});

      await batch.commit();
    } catch (e) {
      setState(() => _isFollowing = false); // Revert optimistic update
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to follow: ${e.toString()}')),
      );
    }
  }

  void _confirmUnfollow() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unfollow'),
        content: const Text('Do you want to unfollow this user?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _unfollowUser();
            },
            child: const Text('Unfollow'),
          ),
        ],
      ),
    );
  }

  Future<void> _unfollowUser() async {
    if (!mounted) return;

    final currentUser = _auth.currentUser;
    if (currentUser == null || currentUser.uid == widget.postData['authorId']) {
      return;
    }

    try {
      await _firestore.runTransaction((transaction) async {
        final followDocId = '${currentUser.uid}_${widget.postData['authorId']}';
        final followDoc = _firestore.collection('follows').doc(followDocId);
        final currentUserDoc =
            _firestore.collection('users').doc(currentUser.uid);
        final targetUserDoc =
            _firestore.collection('users').doc(widget.postData['authorId']);

        transaction.delete(followDoc);
        transaction.update(
            currentUserDoc, {'followingCount': FieldValue.increment(-1)});
        transaction.update(
            targetUserDoc, {'followersCount': FieldValue.increment(-1)});
      });

      if (mounted) {
        setState(() => _isFollowing = false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to unfollow: ${e.toString()}')),
        );
      }
    }
  }

  void _toggleComments() {
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ProviderScope(
        // Add this wrapper
        child: CommentsSheet(postId: widget.postData['id']),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Add debug print to see what data we're receiving
    debugPrint('PostData received: ${widget.postData}');

    final currentUser = FirebaseAuth.instance.currentUser;
    final mediaUrls = (widget.postData['mediaUrls'] as List<dynamic>?) ?? [];
    final likedBy = (widget.postData['likedBy'] as List<dynamic>?) ?? [];
    final isLiked = currentUser != null && likedBy.contains(currentUser.uid);
    final likeCount = widget.postData['likeCount'] ?? 0;

    // Use FutureBuilder to get user data if not in post
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.postData['authorId'])
          .get(),
      builder: (context, userSnapshot) {
        debugPrint('User data snapshot: ${userSnapshot.data?.data()}');

        // Combine post data with user data for display name
        final userData =
            userSnapshot.data?.data() as Map<String, dynamic>? ?? {};
        final String postDisplayName =
            widget.postData['authorName']?.toString().trim() ??
                userData['displayName']?.toString().trim() ??
                userData['username']?.toString().trim() ??
                'Anonymous';

        // NEW: Fixed profile image logic with proper null handling
        final String profileImage = [
          if (widget.postData['authorImage'] != null)
            widget.postData['authorImage'] as String,
          if (userData['photoUrl'] != null) userData['photoUrl'] as String,
          if (userData['photoURL'] != null) userData['photoURL'] as String,
          if (userData['profileImage'] != null)
            userData['profileImage'] as String,
          if (userData['avatar'] != null) userData['avatar'] as String,
          if (userData['coverImage'] != null) userData['coverImage'] as String,
        ].firstWhere((image) => image.trim().isNotEmpty,
            orElse: () =>
                'https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y');

        debugPrint('Using profile image: $profileImage');

        final bool showFollow = currentUser != null &&
            currentUser.uid != widget.postData['authorId'];

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          if (currentUser?.uid != widget.postData['authorId']) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileView(
                                  userId: widget.postData['authorId'],
                                ),
                              ),
                            );
                          }
                        },
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(profileImage),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            postDisplayName,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            widget.postData['role'] ??
                                userData['role'] ??
                                'Member',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    if (showFollow)
                      ElevatedButton(
                        onPressed:
                            _isFollowing ? _confirmUnfollow : _followUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isFollowing
                              ? Colors.grey.shade200
                              : Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              _isFollowing ? Colors.grey : Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                        ),
                        child: Text(_isFollowing ? 'Following' : 'Follow'),
                      ),
                    if (currentUser?.uid == widget.postData['authorId'])
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Post Options'),
                              content: const Text(
                                  'What would you like to do with this post?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    if (currentUser == null) return;
                                    try {
                                      await _firestore
                                          .collection('posts')
                                          .doc(widget.postData['id'])
                                          .update({'isDeleted': true});

                                      // Update user's post count
                                      await _firestore
                                          .collection('users')
                                          .doc(currentUser.uid)
                                          .update({
                                        'postsCount': FieldValue.increment(-1)
                                      });
                                    } catch (e) {
                                      debugPrint('Error deleting post: $e');
                                      if (!mounted) return;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('Failed to delete post: $e'),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text('Delete',
                                      style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
              if (mediaUrls.isNotEmpty)
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(mediaUrls.first),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.postData['title'] != null) ...[
                      Text(
                        widget.postData['title'],
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                    ],
                    if (widget.postData['content'] != null)
                      Text(
                        widget.postData['content'],
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _ActionButton(
                          icon: isLiked
                              ? CupertinoIcons.heart_fill
                              : CupertinoIcons.heart,
                          color: isLiked ? Colors.red : Colors.black,
                          onTap: () async {
                            if (currentUser == null) return;

                            // Store context before async operation
                            final currentContext = context;
                            if (!mounted) return;

                            try {
                              final postRef = _firestore
                                  .collection('posts')
                                  .doc(widget.postData['id']);

                              final postDoc = await postRef.get();
                              if (!postDoc.exists) return;

                              final currentLikedBy = (postDoc.data()?['likedBy']
                                      as List<dynamic>?) ??
                                  [];
                              final isCurrentlyLiked =
                                  currentLikedBy.contains(currentUser.uid);

                              await postRef.update({
                                'likeCount': FieldValue.increment(
                                    isCurrentlyLiked ? -1 : 1),
                                'likedBy': isCurrentlyLiked
                                    ? FieldValue.arrayRemove([currentUser.uid])
                                    : FieldValue.arrayUnion([currentUser.uid]),
                              });
                            } catch (e) {
                              debugPrint('Error toggling like: $e');
                              if (!mounted) return;
                              ScaffoldMessenger.of(currentContext).showSnackBar(
                                SnackBar(
                                    content: Text('Failed to update like: $e')),
                              );
                            }
                          },
                          count: likeCount,
                        ),
                        const SizedBox(width: 16),
                        _ActionButton(
                          icon: CupertinoIcons.chat_bubble,
                          onTap: _toggleComments,
                          count: widget.postData['commentCount'] ?? 0,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _ActionButton(
                          icon: CupertinoIcons.share,
                          onTap: () {},
                        ),
                        const SizedBox(width: 16),
                        _ActionButton(
                          icon: _isSaved
                              ? CupertinoIcons.bookmark_fill
                              : CupertinoIcons.bookmark,
                          onTap: () => setState(() => _isSaved = !_isSaved),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  final int? count;

  const _ActionButton({
    required this.icon,
    required this.onTap,
    this.color,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    // Use theme's icon color by default
    final defaultColor = Theme.of(context).iconTheme.color;
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 24, color: color ?? defaultColor),
          if (count != null) ...[
            const SizedBox(width: 4),
            Text(
              count.toString(),
              style: TextStyle(
                color: color ?? defaultColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
