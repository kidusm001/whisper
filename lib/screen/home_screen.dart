import 'package:flutter/material.dart';
// Removed the problematic import for profile_screen as the file does not exist.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/models/post_model.dart';
import '../providers/saved_posts_provider.dart'; // Import the provider
import 'comment_screen.dart';
import '../providers/likes_provider.dart';
import '../providers/follows_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/interactions_provider.dart';
import '../providers/post_interactions_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final VoidCallback toggleTheme;

  const HomeScreen({
    super.key,
    required this.toggleTheme,
  });

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isSidebarOpen = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuthAndLoadData();
  }

  Future<void> _checkAuthAndLoadData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
        return;
      }
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error checking auth state: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
    });
  }

  void followUser(String userId) {
    // Implement follow user logic here
    print('Following user: $userId');
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create-post');
        },
        backgroundColor: const Color(0xFF320064),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Row(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('createdAt', descending: true)
                  .limit(20)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Error: ${snapshot.error}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {});
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final posts = snapshot.data?.docs
                        .map((doc) => PostModel.fromJson(
                            doc.data() as Map<String, dynamic>))
                        .toList() ??
                    [];

                if (posts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('No posts yet'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/create-post');
                          },
                          child: const Text('Create First Post'),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                  },
                  child: ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return PostCard(
                        post: post,
                        followUser: followUser,
                      );
                    },
                  ),
                );
              },
            ),
          ),
          if (MediaQuery.of(context).size.width > 1200) _buildRightSidebar(),
        ],
      ),
    );
  }

  Widget _buildRightSidebar() {
    final theme = Theme.of(context);
    return Container(
      width: 300,
      color: theme.scaffoldBackgroundColor,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trending Creators',
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // ...existing code or widgets for trending creators...
          Text(
            'Upcoming Events',
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // ...existing code or widgets for upcoming events...
        ],
      ),
    );
  }
}

class PostCard extends ConsumerStatefulWidget {
  const PostCard({
    super.key,
    required this.post,
    required this.followUser,
  });

  final PostModel post;
  final Function(String) followUser;

  @override
  ConsumerState<PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {
  bool _showCheckmark = false;
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _handleFollow(String creatorId) async {
    final result = await Navigator.pushNamed(context, '/subscription-tiers');
    if (result != null && result is String) {
      ref.read(followsProvider.notifier).followCreator(creatorId, result);
      setState(() {
        _showCheckmark = true;
      });
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _showCheckmark = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFollowing =
        ref.watch(followsProvider).following[widget.post.authorId] ?? false;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.post.authorId)
          .snapshots(),
      builder: (context, snapshot) {
        final userData = snapshot.data?.data() as Map<String, dynamic>?;
        final userPhotoUrl = userData?['photoUrl'] as String?;

        return Card(
          margin: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: userPhotoUrl != null
                      ? NetworkImage(userPhotoUrl)
                      : const NetworkImage('https://placeholder.com/50x50'),
                ),
                title: Text(
                  widget.post.authorName ?? 'Anonymous',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: widget.post.tier != null
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color:
                              _getTierColor(widget.post.tier!).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: _getTierColor(widget.post.tier!)),
                        ),
                        child: Text(
                          widget.post.tier!.toUpperCase(),
                          style: TextStyle(
                            color: _getTierColor(widget.post.tier!),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : null,
                trailing: !isFollowing
                    ? IconButton(
                        icon: Icon(
                          _showCheckmark
                              ? Icons.check_circle
                              : Icons.person_add,
                          color: _showCheckmark
                              ? Colors.green
                              : theme.iconTheme.color,
                        ),
                        onPressed: () => _handleFollow(widget.post.authorId),
                      )
                    : null,
              ),
              if (widget.post.mediaUrls.isNotEmpty)
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.post.mediaUrls.first),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post.title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.post.content,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    StreamBuilder<bool>(
                      stream: ref
                          .read(postInteractionsProvider.notifier)
                          .hasUserLiked(widget.post.id),
                      builder: (context, snapshot) {
                        final isLiked = snapshot.data ?? false;
                        return IconButton(
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? Colors.red : null,
                          ),
                          onPressed: () => ref
                              .read(postInteractionsProvider.notifier)
                              .toggleLike(widget.post.id),
                        );
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => StreamBuilder<QuerySnapshot>(
                            stream: ref
                                .read(postInteractionsProvider.notifier)
                                .getLikes(widget.post.id),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              final likes = snapshot.data?.docs ?? [];

                              return Column(
                                children: [
                                  AppBar(
                                    title: Text('${likes.length} Likes'),
                                    leading: IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: likes.length,
                                      itemBuilder: (context, index) {
                                        final like = likes[index].data()
                                            as Map<String, dynamic>;
                                        return ListTile(
                                          leading: const CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                'https://placeholder.com/50x50'),
                                          ),
                                          title: Text(
                                              like['userName'] ?? 'Anonymous'),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      },
                      child: Text('${widget.post.likesCount} likes'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.comment_outlined),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => DraggableScrollableSheet(
                            initialChildSize: 0.9,
                            minChildSize: 0.5,
                            maxChildSize: 0.95,
                            builder: (_, controller) => Column(
                              children: [
                                AppBar(
                                  title: const Text('Comments'),
                                  leading: IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ),
                                Expanded(
                                  child: StreamBuilder<QuerySnapshot>(
                                    stream: ref
                                        .read(postInteractionsProvider.notifier)
                                        .getComments(widget.post.id),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'),
                                        );
                                      }

                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }

                                      final comments =
                                          snapshot.data?.docs ?? [];

                                      return Column(
                                        children: [
                                          Expanded(
                                            child: ListView.builder(
                                              controller: controller,
                                              itemCount: comments.length,
                                              itemBuilder: (context, index) {
                                                final comment =
                                                    comments[index].data()
                                                        as Map<String, dynamic>;
                                                return ListTile(
                                                  leading: const CircleAvatar(
                                                    backgroundImage: NetworkImage(
                                                        'https://placeholder.com/50x50'),
                                                  ),
                                                  title: Text(
                                                    comment['authorName'] ??
                                                        'Anonymous',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  subtitle:
                                                      Text(comment['content']),
                                                );
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom,
                                              left: 8,
                                              right: 8,
                                              top: 8,
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: TextField(
                                                    controller:
                                                        _commentController,
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText:
                                                          'Add a comment...',
                                                      border:
                                                          OutlineInputBorder(),
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.send),
                                                  onPressed: () {
                                                    if (_commentController
                                                        .text.isNotEmpty) {
                                                      ref
                                                          .read(
                                                              postInteractionsProvider
                                                                  .notifier)
                                                          .addComment(
                                                            widget.post.id,
                                                            _commentController
                                                                .text,
                                                          );
                                                      _commentController
                                                          .clear();
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    Text('${widget.post.commentsCount} comments'),
                    const Spacer(),
                    StreamBuilder<bool>(
                      stream: ref
                          .read(postInteractionsProvider.notifier)
                          .hasUserSaved(widget.post.id),
                      builder: (context, snapshot) {
                        final isSaved = snapshot.data ?? false;
                        return IconButton(
                          icon: Icon(
                            isSaved ? Icons.bookmark : Icons.bookmark_border,
                            color: isSaved ? theme.colorScheme.primary : null,
                          ),
                          onPressed: () => ref
                              .read(postInteractionsProvider.notifier)
                              .toggleSavePost(widget.post.id),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Color _getTierColor(String tier) {
    switch (tier.toLowerCase()) {
      case 'basic':
        return Colors.blue;
      case 'premium':
        return Colors.purple;
      case 'vip':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
