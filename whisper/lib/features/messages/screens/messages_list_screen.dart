import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timeago/timeago.dart' as timeago;
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
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF320064),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SearchBar(
              hintText: 'Search conversations...',
              backgroundColor: MaterialStateProperty.all(Colors.white),
              elevation: MaterialStateProperty.all(0),
              padding: const MaterialStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 16),
              ),
              leading: const Icon(Icons.search),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('follows')
                  .where('followingId', isEqualTo: currentUser.uid)
                  .snapshots(),
              builder: (context, followingSnapshot) {
                if (followingSnapshot.hasError) {
                  return Center(
                      child: Text('Error: ${followingSnapshot.error}'));
                }

                if (!followingSnapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final followers = followingSnapshot.data!.docs;

                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('follows')
                      .where('followerId', isEqualTo: currentUser.uid)
                      .snapshots(),
                  builder: (context, followerSnapshot) {
                    if (followerSnapshot.hasError) {
                      return Center(
                          child: Text('Error: ${followerSnapshot.error}'));
                    }

                    if (!followerSnapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final following = followerSnapshot.data!.docs;

                    final mutualFollows = followers.where((followerDoc) {
                      return following.any((followingDoc) =>
                          followerDoc['followerId'] ==
                          followingDoc['followingId']);
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
                        final otherUserId = mutualFollow['followerId'];

                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('users')
                              .doc(otherUserId)
                              .get(),
                          builder: (context, userSnapshot) {
                            if (userSnapshot.hasError) {
                              return const SizedBox.shrink();
                            }
                            if (!userSnapshot.hasData) {
                              return const SizedBox.shrink();
                            }

                            final userData = userSnapshot.data!.data()
                                as Map<String, dynamic>;
                            userData['uid'] = otherUserId;
                            final otherUser = UserModel.fromJson(userData);

                            return _ChatListTile(
                              otherUser: otherUser,
                              currentUserId: currentUser.uid,
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
          ),
        ],
      ),
    );
  }
}

class _ChatListTile extends StatelessWidget {
  final UserModel otherUser;
  final String currentUserId;
  final VoidCallback onTap;

  const _ChatListTile({
    required this.otherUser,
    required this.currentUserId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final chatRoomId = [currentUserId, otherUser.uid]..sort();
    final roomId = chatRoomId.join('_');

    return ListTile(
      onTap: onTap,
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: otherUser.photoUrl != null
                ? NetworkImage(otherUser.photoUrl!)
                : null,
            child: otherUser.photoUrl == null
                ? const Icon(Icons.person, size: 32)
                : null,
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(otherUser.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox();

              final userData = snapshot.data!.data() as Map<String, dynamic>?;
              final isOnline = userData?['isOnline'] ?? false;
              if (!isOnline) return const SizedBox();

              return Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              otherUser.displayName ?? 'Anonymous',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('chatRooms')
                .doc(roomId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox();

              final data = snapshot.data!.data() as Map<String, dynamic>?;
              if (data == null) return const SizedBox();

              final lastMessageTime =
                  (data['lastMessageTime'] as Timestamp?)?.toDate();
              if (lastMessageTime == null) return const SizedBox();

              return Text(
                timeago.format(lastMessageTime, allowFromNow: true),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              );
            },
          ),
        ],
      ),
      subtitle: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chatRooms')
            .doc(roomId)
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .limit(1)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Text('Start a conversation',
                style: TextStyle(fontStyle: FontStyle.italic));
          }

          final lastMessage =
              snapshot.data!.docs.first.data() as Map<String, dynamic>;
          final isTyping = lastMessage['typing'] ?? false;

          if (isTyping) {
            return Row(
              children: [
                Container(
                  width: 40,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const ThreeDotsLoadingIndicator(),
                ),
                const Text(
                  'typing...',
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            );
          }

          return Text(
            lastMessage['content'] as String? ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: lastMessage['isRead'] == false &&
                      lastMessage['senderId'] != currentUserId
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          );
        },
      ),
    );
  }
}

class ThreeDotsLoadingIndicator extends StatefulWidget {
  const ThreeDotsLoadingIndicator({super.key});

  @override
  State<ThreeDotsLoadingIndicator> createState() =>
      _ThreeDotsLoadingIndicatorState();
}

class _ThreeDotsLoadingIndicatorState extends State<ThreeDotsLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final double offset = index * 0.3;
            final double t = (_controller.value + offset) % 1.0;
            return Transform.translate(
              offset: Offset(0, -2 * sin(t * pi)),
              child: Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        );
      }),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
