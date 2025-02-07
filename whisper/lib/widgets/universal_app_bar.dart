import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UniversalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onMenuPressed;

  const UniversalAppBar({
    super.key,
    required this.title,
    required this.onMenuPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: onMenuPressed,
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            // Implement search functionality
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            // Implement notifications
          },
        ),
        const SizedBox(width: 8),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(currentUser?.uid)
                .get(),
            builder: (context, snapshot) {
              final userData =
                  snapshot.data?.data() as Map<String, dynamic>? ?? {};
              final String profileImage = [
                if (userData['photoUrl'] != null)
                  userData['photoUrl'] as String,
                if (userData['photoURL'] != null)
                  userData['photoURL'] as String,
                if (userData['profileImage'] != null)
                  userData['profileImage'] as String,
                if (userData['avatar'] != null) userData['avatar'] as String,
              ].firstWhere((image) => image.trim().isNotEmpty,
                  orElse: () =>
                      'https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y');

              return GestureDetector(
                onTap: () => Scaffold.of(context).openEndDrawer(),
                child: CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(profileImage),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
