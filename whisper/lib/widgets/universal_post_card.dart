import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UniversalPostCard extends StatefulWidget {
  final Map<String, dynamic> postData;
  const UniversalPostCard({super.key, required this.postData});

  @override
  State<UniversalPostCard> createState() => _UniversalPostCardState();
}

class _UniversalPostCardState extends State<UniversalPostCard> {
  bool _isFollowing = false;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _checkIfFollowing();
  }

  Future<void> _checkIfFollowing() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null || currentUser.uid == widget.postData['authorId']) {
      return;
    }
    final doc = await _firestore
        .collection('follows')
        .doc('${currentUser.uid}_${widget.postData['authorId']}')
        .get();
    if (doc.exists) {
      setState(() {
        _isFollowing = true;
      });
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

      batch.update(targetUserDoc, {'followerCount': FieldValue.increment(1)});

      await batch.commit();
    } catch (e) {
      setState(() => _isFollowing = false); // Revert optimistic update
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to follow: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaUrls = (widget.postData['mediaUrls'] as List<dynamic>?) ?? [];
    final currentUser = FirebaseAuth.instance.currentUser;
    final bool showFollow =
        currentUser != null && currentUser.uid != widget.postData['authorId'];

    // Fix String? type issue with proper null check and default value
    final String authorName =
        ((widget.postData['authorName'] as String?) ?? '').trim();
    final displayName = authorName.isNotEmpty ? authorName : "Anonymous";

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with author info
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(widget.postData['authorImage'] ??
                  'https://placeholder.com/50x50'),
            ),
            title: Text(
              displayName, // Updated display name
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black),
            ),
            subtitle: Text(
              widget.postData['role'] ?? 'Member',
              style: const TextStyle(color: Colors.grey),
            ),
            trailing: showFollow
                ? TextButton(
                    onPressed: _isFollowing ? null : _followUser,
                    child: Text(
                      _isFollowing ? 'Following' : 'Follow',
                      style: TextStyle(
                        color: _isFollowing ? Colors.grey : Colors.blue,
                      ),
                    ),
                  )
                : null,
          ),
          // Post title and content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.postData['title'] != null)
                  Text(
                    widget.postData['title'],
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                const SizedBox(height: 8),
                if (widget.postData['content'] != null)
                  Text(
                    widget.postData['content'],
                    style: const TextStyle(color: Colors.grey),
                  ),
              ],
            ),
          ),
          // Media content if exists
          if (mediaUrls.isNotEmpty)
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(mediaUrls.first),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          // Action buttons
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite_border, color: Colors.black),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.comment_outlined, color: Colors.black),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.black),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.bookmark_border, color: Colors.black),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
