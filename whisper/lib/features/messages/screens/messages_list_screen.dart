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
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .snapshots(),
        builder: (context, userSnapshot) {
          if (!userSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final userData = userSnapshot.data!.data() as Map<String, dynamic>;
          final subscriptions = (userData['subscriptions'] as List<dynamic>?) ?? [];

          if (subscriptions.isEmpty) {
            return const Center(
              child: Text('Subscribe to creators to start messaging!'),
            );
          }

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where(FieldPath.documentId, whereIn: subscriptions)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final creators = snapshot.data!.docs;

              return ListView.builder(
                itemCount: creators.length,
                itemBuilder: (context, index) {
                  final creatorData = creators[index].data() as Map<String, dynamic>;
                  final creator = UserModel.fromJson(creatorData);

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: creator.photoUrl != null
                          ? NetworkImage(creator.photoUrl!)
                          : null,
                      child: creator.photoUrl == null
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    title: Text(creator.displayName ?? 'Anonymous'),
                    subtitle: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('messages')
                          .where('participants', arrayContains: currentUser.uid)
                          .orderBy('timestamp', descending: true)
                          .limit(1)
                          .snapshots(),
                      builder: (context, messageSnapshot) {
                        if (!messageSnapshot.hasData ||
                            messageSnapshot.data!.docs.isEmpty) {
                          return const Text('No messages yet');
                        }

                        final lastMessage =
                            messageSnapshot.data!.docs.first.data() as Map<String, dynamic>;
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
                            otherUser: creator,
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
      ),
    );
  }
} 