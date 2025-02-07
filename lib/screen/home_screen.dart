import 'package:flutter/material.dart';
import 'package:whisper/features/profile/screens/profile_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/models/post_model.dart';
import '../providers/saved_posts_provider.dart'; // Import the provider
import '../features/screens/comment_screen.dart';
import '../providers/likes_provider.dart';
import '../providers/follows_provider.dart';

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
    // Dummy data for demonstration; fixed second PostModel
    final List<PostModel> posts = [
      PostModel(
        id: '1',
        authorId: 'user1',
        title: 'First Post',
        content: 'This is the first post content.',
        mediaUrls: [],
        mediaType: 'text',
        createdAt: DateTime.now(),
      ),
      PostModel(
        id: '2',
        authorId: 'user2',
        title: 'Second Post',
        content: 'This is the second post content.',
        mediaUrls: [],
        mediaType: 'text',
        createdAt: DateTime.now(),
      ),
    ];

    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Row(
        children: [
          Expanded(
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

  void _handleFollow(String creatorId) async {
    final result = await Navigator.pushNamed(context, '/subscription-tiers');
    if (result != null && result is String) {
      ref.read(followsProvider.notifier).followCreator(creatorId, result);
      setState(() {
        _showCheckmark = true;
      });
      // Show checkmark briefly before hiding the button
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
    final isSaved =
        ref.watch(savedPostsProvider.notifier).isPostSaved(widget.post);
    final isLiked =
        ref.watch(likesProvider).likedPosts[widget.post.id] ?? false;
    final likeCount = ref.watch(likesProvider).likeCounts[widget.post.id] ??
        widget.post.likesCount;
    final isFollowing =
        ref.watch(followsProvider).following[widget.post.authorId] ?? false;
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const CircleAvatar(
                backgroundImage: NetworkImage('https://placeholder.com/50x50'),
              ),
              title: Text(
                'Creator Name',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Premium Member',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.hintColor,
                ),
              ),
              trailing: !isFollowing
                  ? IconButton(
                      icon: Icon(
                        _showCheckmark ? Icons.check_circle : Icons.person_add,
                        color: _showCheckmark
                            ? Colors.green
                            : theme.iconTheme.color,
                      ),
                      onPressed: () => _handleFollow(widget.post.authorId),
                    )
                  : null,
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
                  const SizedBox(height: 16),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'Media Content',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.hintColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: theme.dividerColor),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : theme.iconTheme.color,
                    ),
                    onPressed: () {
                      ref.read(likesProvider.notifier).toggleLike(
                            widget.post.id,
                            widget.post.likesCount,
                          );
                    },
                  ),
                  Text('$likeCount Likes'),
                  IconButton(
                    icon: Icon(Icons.comment_outlined,
                        color: theme.iconTheme.color),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CommentScreen(post: widget.post),
                        ),
                      );
                    },
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      isSaved ? Icons.bookmark : Icons.bookmark_border,
                      color: isSaved
                          ? Theme.of(context).colorScheme.primary
                          : theme.iconTheme.color,
                      size: isSaved ? 28 : 24,
                    ),
                    onPressed: () {
                      final enrichedPost = PostModel(
                        id: widget.post.id,
                        authorId: widget.post.authorId,
                        title: widget.post.title,
                        content: widget.post.content,
                        mediaUrls: widget.post.mediaUrls,
                        mediaType: widget.post.mediaType,
                        createdAt: widget.post.createdAt,
                        authorName: 'Creator Name',
                        likesCount: likeCount,
                        commentsCount: widget.post.commentsCount,
                      );
                      ref
                          .read(savedPostsProvider.notifier)
                          .togglePost(enrichedPost);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
