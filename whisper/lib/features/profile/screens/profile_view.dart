import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/widgets/universal_post_card.dart';

class ProfileView extends ConsumerStatefulWidget {
  final String userId;
  const ProfileView({super.key, required this.userId});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  bool _isFollowing = false;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _checkIfFollowing();
  }

  Future<void> _checkIfFollowing() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return;

      final doc = await _firestore
          .collection('follows')
          .doc('${currentUser.uid}_${widget.userId}')
          .get();

      if (doc.exists && mounted) {
        setState(() {
          _isFollowing = true;
        });
      }
    } catch (e) {
      debugPrint('Error checking follow status: $e');
    }
  }

  Future<void> _toggleFollow() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    try {
      if (_isFollowing) {
        // Unfollow
        final batch = _firestore.batch();
        final followDocId = '${currentUser.uid}_${widget.userId}';
        final followDoc = _firestore.collection('follows').doc(followDocId);
        batch.delete(followDoc);

        final currentUserDoc =
            _firestore.collection('users').doc(currentUser.uid);
        final targetUserDoc = _firestore.collection('users').doc(widget.userId);

        batch.update(
            currentUserDoc, {'followingCount': FieldValue.increment(-1)});
        batch.update(
            targetUserDoc, {'followersCount': FieldValue.increment(-1)});

        await batch.commit();
        if (mounted) setState(() => _isFollowing = false);
      } else {
        // Follow
        final batch = _firestore.batch();
        final followDocId = '${currentUser.uid}_${widget.userId}';
        final followDoc = _firestore.collection('follows').doc(followDocId);

        batch.set(followDoc, {
          'followerId': currentUser.uid,
          'followingId': widget.userId,
          'createdAt': FieldValue.serverTimestamp(),
        });

        final currentUserDoc =
            _firestore.collection('users').doc(currentUser.uid);
        final targetUserDoc = _firestore.collection('users').doc(widget.userId);

        batch.update(
            currentUserDoc, {'followingCount': FieldValue.increment(1)});
        batch
            .update(targetUserDoc, {'followersCount': FieldValue.increment(1)});

        await batch.commit();
        if (mounted) setState(() => _isFollowing = true);
      }
    } catch (e) {
      debugPrint('Error toggling follow: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Failed to ${_isFollowing ? 'unfollow' : 'follow'}: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: _firestore.collection('users').doc(widget.userId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: userData['coverImage'] != null
                      ? Image.network(
                          userData['coverImage'],
                          fit: BoxFit.cover,
                        )
                      : Container(color: Colors.grey[200]),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: _toggleFollow,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isFollowing
                            ? Colors.grey[200]
                            : Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            _isFollowing ? Colors.grey[800] : Colors.white,
                      ),
                      child: Text(_isFollowing ? 'Following' : 'Follow'),
                    ),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Transform.translate(
                      offset: const Offset(0, -40),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: userData['photoUrl'] != null
                            ? NetworkImage(userData['photoUrl'])
                            : null,
                        child: userData['photoUrl'] == null
                            ? const Icon(Icons.person, size: 50)
                            : null,
                      ),
                    ),
                    Text(
                      userData['displayName'] ?? 'Anonymous',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    if (userData['bio'] != null) ...[
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          userData['bio'],
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStat('Posts', userData['postsCount'] ?? 0),
                        _buildStat(
                            'Followers', userData['followersCount'] ?? 0),
                        _buildStat(
                            'Following', userData['followingCount'] ?? 0),
                      ],
                    ),
                    const Divider(height: 32),
                  ],
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('posts')
                    .where('authorId', isEqualTo: widget.userId)
                    .where('isDeleted', isEqualTo: false)
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return SliverToBoxAdapter(
                      child: Center(child: Text('Error: ${snapshot.error}')),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final posts = snapshot.data!.docs;

                  if (posts.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('No posts yet'),
                        ),
                      ),
                    );
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final postData =
                            posts[index].data() as Map<String, dynamic>;
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: UniversalPostCard(postData: postData),
                        );
                      },
                      childCount: posts.length,
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStat(String label, int value) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
