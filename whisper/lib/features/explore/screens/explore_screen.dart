import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whisper/widgets/universal_post_card.dart';
import 'package:whisper/widgets/universal_app_bar.dart'; // <-- Added import
import 'package:whisper/widgets/universal_drawer.dart'; // <-- Added import

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey =
        GlobalKey<ScaffoldState>(); // <-- New key
    debugPrint('Building ExploreScreen');
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    debugPrint('Current User ID: $currentUserId');

    return Scaffold(
      key: scaffoldKey, // <-- Assign key
      appBar: UniversalAppBar(
        title: 'Explore Posts',
        onMenuPressed: () {
          scaffoldKey.currentState?.openDrawer(); // <-- Use key to open drawer
        },
      ),
      drawer: const UniversalDrawer(),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseAuth.instance.currentUser != null
            ? FirebaseFirestore.instance
                .collection('posts')
                .where('isDeleted', isEqualTo: false)
                .snapshots()
            : const Stream.empty(), // Return empty stream if not authenticated
        builder: (context, snapshot) {
          debugPrint('StreamBuilder state: ${snapshot.connectionState}');
          if (snapshot.hasError) {
            debugPrint('Error in ExploreScreen: ${snapshot.error}');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Something went wrong\n${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            debugPrint('Loading posts...');
            return const Center(child: CircularProgressIndicator());
          }
          final allPosts = snapshot.data?.docs ?? [];
          debugPrint('Retrieved ${allPosts.length} posts');
          // In-memory filtering and ordering by createdAt descending
          final posts = allPosts.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return data['authorId'] != currentUserId;
          }).toList()
            ..sort((a, b) {
              final aDate =
                  (a.data() as Map<String, dynamic>)['createdAt'] as Timestamp;
              final bDate =
                  (b.data() as Map<String, dynamic>)['createdAt'] as Timestamp;
              return bDate.compareTo(aDate);
            });
          if (posts.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.explore_off, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No posts to explore yet'),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final postData = posts[index].data() as Map<String, dynamic>;
              debugPrint('Building post $index with data: $postData');
              return UniversalPostCard(postData: postData);
            },
          );
        },
      ),
    );
  }
}
