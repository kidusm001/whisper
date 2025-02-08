import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/user_model.dart';
import 'chat_screen.dart';

class MessagesListScreen extends StatelessWidget {
  const MessagesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text('Please login to view messages')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        backgroundColor: const Color(0xFF320064),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Stream of users who follow the current user
        stream: FirebaseFirestore.instance
            .collection('follows')
            .where('followingId', isEqualTo: currentUser.uid)
            .snapshots(),
        builder: (context, followingSnapshot) {
          if (followingSnapshot.hasError) {
            return Center(child: Text('Error: ${followingSnapshot.error}'));
          }

          if (!followingSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final followers = followingSnapshot.data!.docs;

          return StreamBuilder<QuerySnapshot>(
            // Stream of users that the current user follows
            stream: FirebaseFirestore.instance
                .collection('follows')
                .where('followerId', isEqualTo: currentUser.uid)
                .snapshots(),
            builder: (context, followerSnapshot) {
              if (followerSnapshot.hasError) {
                return Center(child: Text('Error: ${followerSnapshot.error}'));
              }

              if (!followerSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final following = followerSnapshot.data!.docs;

              // Find mutual follows (users who follow each other)
              final mutualFollows = followers.where((followerDoc) {
                return following.any((followingDoc) =>
                    followerDoc['followerId'] == followingDoc['followingId']);
              }).toList();

              if (mutualFollows.isEmpty) {
                return const Center(
                  child: Text('No mutual follows yet. Start following!'),
                );
              }

              return ListView.builder(
                itemCount: mutualFollows.length,
                itemBuilder: (context, index) {
                  final mutualFollow = mutualFollows[index];
                  final otherUserId = mutualFollow['followerId']; // The other user's ID

                  return FutureBuilder<DocumentSnapshot>(
                    // Fetch the other user's data
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(otherUserId)
                        .get(),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.hasError) {
                        return const SizedBox.shrink(); // Or some error indicator
                      }
                      if (!userSnapshot.hasData) {
                        return const SizedBox
                            .shrink(); // Or a loading indicator
                      }

                      final userData =
                          userSnapshot.data!.data() as Map<String, dynamic>;
                      userData['uid'] = otherUserId; // Ensure UID is present
                      final otherUser = UserModel.fromJson(userData);

                      // Create chat room ID
                      final chatRoomId = [currentUser.uid, otherUser.uid]
                        ..sort();
                      final roomId = chatRoomId.join('_');

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: otherUser.photoUrl != null
                              ? NetworkImage(otherUser.photoUrl!)
                              : null,
                          child: otherUser.photoUrl == null
                              ? const Icon(Icons.person)
                              : null,
                        ),
                        title: Text(otherUser.displayName ?? 'Anonymous'),
                        subtitle: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('chatRooms')
                              .doc(roomId)
                              .collection('messages')
                              .orderBy('timestamp', descending: true)
                              .limit(1)
                              .snapshots(),
                          builder: (context, messageSnapshot) {
                            if (!messageSnapshot.hasData ||
                                messageSnapshot.data!.docs.isEmpty) {
                              return const Text('No messages yet');
                            }

                            final lastMessage = messageSnapshot.data!.docs.first
                                .data() as Map<String, dynamic>;
                            return Text(
                              lastMessage['content'] as String? ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            );
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                otherUser: otherUser,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
} 