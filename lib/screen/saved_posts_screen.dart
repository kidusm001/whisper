import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/saved_posts_provider.dart';
import '../providers/likes_provider.dart';
import '../features/screens/comment_screen.dart';

class SavedPostsScreen extends ConsumerWidget {
  const SavedPostsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedPosts = ref.watch(savedPostsProvider);
    final likesState = ref.watch(likesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Posts'),
      ),
      body: savedPosts.isEmpty
          ? const Center(
              child: Text('No saved posts yet.'),
            )
          : ListView.builder(
              itemCount: savedPosts.length,
              itemBuilder: (context, index) {
                final post = savedPosts[index];
                final isLiked = likesState.likedPosts[post.id] ?? false;
                final likeCount =
                    likesState.likeCounts[post.id] ?? post.likesCount;

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const CircleAvatar(
                            backgroundImage:
                                NetworkImage('https://placeholder.com/50x50'),
                          ),
                          title: Text(
                            post.authorName ?? 'Creator',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          post.title,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          post.content,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).hintColor,
                                  ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isLiked
                                    ? Colors.red
                                    : Theme.of(context).iconTheme.color,
                              ),
                              onPressed: () {
                                ref.read(likesProvider.notifier).toggleLike(
                                      post.id,
                                      post.likesCount,
                                    );
                              },
                            ),
                            Text('$likeCount Likes'),
                            IconButton(
                              icon: Icon(
                                Icons.comment_outlined,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CommentScreen(post: post),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
